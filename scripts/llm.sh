#!/bin/bash

set -euo pipefail

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

# Install Claude Code via the official native installer instead of Homebrew:
# the cask lags behind native/npm releases, and the native installer
# self-updates. `brew bundle` runs without --cleanup, so dropping the cask
# from the Brewfile does not remove it from a machine that already has it.
if command -v claude >/dev/null 2>&1; then
  case "$(command -v claude)" in
  /opt/homebrew/Caskroom/* | /usr/local/Caskroom/*)
    printf "Claude Code is installed via Homebrew; migrate with:\n"
    printf "  brew uninstall --cask claude-code && bash %s\n" "$0"
    ;;
  esac
else
  printf "Installing Claude Code...\n"
  curl -fsSL https://claude.ai/install.sh | bash
fi

# Link Claude Code config
printf "Setting up Claude Code configuration...\n"

readonly CLAUDE_CONFIG_DIR="$HOME/.claude"
[ ! -d "$CLAUDE_CONFIG_DIR" ] && mkdir -p "$CLAUDE_CONFIG_DIR"

readonly DOTFILES_LLM="$REPO_DIR/llm"

# Link CLAUDE.md (AGENTS.md)
readonly CLAUDE_AGENTS_FILE="$CLAUDE_CONFIG_DIR/CLAUDE.md"
[ ! -e "$CLAUDE_AGENTS_FILE" ] && ln -fs "$DOTFILES_LLM/AGENTS.md" "$CLAUDE_AGENTS_FILE"

# settings.json is per-machine and not tracked here; only the hook registrations
# below and the permission rules edit it, with jq, which needs the file to exist.
readonly CLAUDE_SETTINGS_FILE="$CLAUDE_CONFIG_DIR/settings.json"
[ ! -e "$CLAUDE_SETTINGS_FILE" ] && echo '{}' >"$CLAUDE_SETTINGS_FILE"

# Report vendored skills whose upstream has moved past the commit they were
# reviewed through. Forking these skills is deliberate -- the local copies carry
# changes upstream does not want -- so this only prints: upstream prompt changes
# are merged by hand after review, never applied automatically.
readonly UPSTREAM_MANIFEST="$DOTFILES_LLM/upstream-skills.tsv"
if [ ! -f "$UPSTREAM_MANIFEST" ]; then
  :
elif ! command -v gh >/dev/null 2>&1; then
  printf "gh not found; skipping the vendored skill drift check.\n"
else
  printf "Checking vendored skills against upstream...\n"
  while IFS=$'\t' read -r skill repo path sha || [ -n "${skill:-}" ]; do
    case "$skill" in '' | '#'*) continue ;; esac
    latest="$(gh api "repos/$repo/commits?path=$path&per_page=1" --jq '.[0].sha' 2>/dev/null || true)"
    if [ -z "$latest" ]; then
      printf "  %s: could not reach upstream; skipped.\n" "$skill"
    elif [ "$latest" = "$sha" ]; then
      printf "  %s: up to date.\n" "$skill"
    else
      printf "  %s: upstream moved (%s).\n" "$skill" "$path"
      printf "    https://github.com/%s/compare/%s...%s\n" "$repo" "$sha" "$latest"
      printf "    Review it, then update llm/upstream-skills.tsv.\n"
    fi
  done <"$UPSTREAM_MANIFEST"
fi

# Set up herdr as the substrate for agent work
if command -v herdr >/dev/null 2>&1; then
  # Regenerate the herdr skill from the installed binary so it tracks herdr
  # upgrades. The output is git-ignored: it is generated, not hand-written.
  printf "Generating herdr skill...\n"
  readonly HERDR_SKILL_DIR="$DOTFILES_LLM/skills/herdr"
  [ ! -d "$HERDR_SKILL_DIR" ] && mkdir -p "$HERDR_SKILL_DIR"
  herdr --skill >"$HERDR_SKILL_DIR/SKILL.md"

  # Override the generated description. herdr ships one that gates the skill on
  # the user naming herdr in the prompt ("use only when the user explicitly
  # mentions Herdr"), which cancels the standing request in llm/AGENTS.md: the
  # description is what the model reads when deciding which skill to reach for,
  # so the skill never fires unprompted. Only that one line is rewritten; the
  # generated body stays as the installed binary produced it.
  readonly HERDR_SKILL_DESCRIPTION='description: "Control Herdr, a terminal multiplexer for coding agents. Use whenever starting, delegating to, or waiting on another AI agent, and whenever the user mentions Herdr or asks to inspect or control panes, tabs, workspaces, commands, or agents. A standing request in ~/.claude/CLAUDE.md already covers the unprompted case, so no per-task mention is needed. Requires HERDR_ENV=1."'
  if grep -q '^description:' "$HERDR_SKILL_DIR/SKILL.md"; then
    skill_tmp="$(mktemp)"
    awk -v desc="$HERDR_SKILL_DESCRIPTION" '
      !replaced && /^description:/ { print desc; replaced = 1; next }
      { print }
    ' "$HERDR_SKILL_DIR/SKILL.md" >"$skill_tmp" \
      && mv -f "$skill_tmp" "$HERDR_SKILL_DIR/SKILL.md" \
      || rm -f "$skill_tmp"
  else
    printf "herdr skill has no description line; leaving it unchanged.\n"
  fi

  # Install the agent state hook so herdr can read Claude Code's
  # working/idle/blocked/done state. Re-running reinstalls the current version.
  printf "Installing herdr integration for Claude Code...\n"
  herdr integration install claude

  # Link the "one repository = one workspace" SessionStart hook. It lives in
  # this repository (unlike herdr's own hook, which herdr installs above), so it
  # is symlinked rather than copied.
  printf "Linking herdr repo-workspace hook...\n"
  readonly CLAUDE_HOOKS_DIR="$CLAUDE_CONFIG_DIR/hooks"
  [ ! -d "$CLAUDE_HOOKS_DIR" ] && mkdir -p "$CLAUDE_HOOKS_DIR"
  readonly REPO_WORKSPACE_HOOK="$CLAUDE_HOOKS_DIR/herdr-repo-workspace.sh"
  [ ! -e "$REPO_WORKSPACE_HOOK" ] \
    && ln -fs "$DOTFILES_LLM/hooks/herdr-repo-workspace.sh" "$REPO_WORKSPACE_HOOK"

  # Register it on SessionStart. This has to append to the same hooks block that
  # `herdr integration install claude` writes, so it is merged in with jq.
  readonly REPO_WORKSPACE_HOOK_COMMAND='bash "$HOME/.claude/hooks/herdr-repo-workspace.sh"'
  if ! command -v jq >/dev/null 2>&1; then
    printf "jq not found; skipping SessionStart hook registration.\n"
  elif jq -e --arg cmd "$REPO_WORKSPACE_HOOK_COMMAND" \
      '[(.hooks.SessionStart // [])[].hooks[]?.command] | index($cmd)' \
      "$CLAUDE_SETTINGS_FILE" >/dev/null 2>&1; then
    printf "herdr repo-workspace hook already registered.\n"
  else
    printf "Registering herdr repo-workspace hook on SessionStart...\n"
    settings_tmp="$(mktemp)"
    jq --arg cmd "$REPO_WORKSPACE_HOOK_COMMAND" \
      '.hooks.SessionStart = ((.hooks.SessionStart // []) + [{
         matcher: "*",
         hooks: [{ type: "command", command: $cmd, timeout: 15 }]
       }])' "$CLAUDE_SETTINGS_FILE" >"$settings_tmp" \
      && mv -f "$settings_tmp" "$CLAUDE_SETTINGS_FILE" \
      || rm -f "$settings_tmp"
  fi
else
  printf "herdr not found; skipping herdr skill and integration.\n"
fi

# Link each skill on its own. omarchy creates ~/.claude/skills as a real
# directory holding its own skills, so a directory-level link would be skipped
# there; per-skill links also keep skills written into ~/.claude/skills (by
# AutoHarness, omarchy) out of this repository. This runs after the herdr block
# so the generated herdr skill is linked on the first run too.
printf "Linking skills...\n"
readonly CLAUDE_SKILLS_DIR="$CLAUDE_CONFIG_DIR/skills"
if [ "$(readlink "$CLAUDE_SKILLS_DIR" 2>/dev/null || true)" = "$DOTFILES_LLM/skills" ]; then
  rm "$CLAUDE_SKILLS_DIR"
fi
mkdir -p "$CLAUDE_SKILLS_DIR"
for skill_dir in "$DOTFILES_LLM"/skills/*/; do
  skill_dest="$CLAUDE_SKILLS_DIR/$(basename "$skill_dir")"
  if [ ! -e "$skill_dest" ] && [ ! -L "$skill_dest" ]; then
    ln -s "${skill_dir%/}" "$skill_dest"
  fi
done

# Link the shut-up-and-code hooks and turn always-on mode on by default. The
# skill's own routing description ("use when writing or editing code") is not
# enough on its own -- see llm/skills/shut-up-and-code/SKILL.md's upstream
# README on why a CLAUDE.md line and skill routing alone do not reliably
# suppress verbose comments -- so these hooks force the ruleset into context
# instead of waiting for the model to decide to call the skill.
printf "Linking shut-up-and-code hooks...\n"
readonly SUAC_HOOKS_DIR="$CLAUDE_CONFIG_DIR/hooks"
[ ! -d "$SUAC_HOOKS_DIR" ] && mkdir -p "$SUAC_HOOKS_DIR"
readonly SUAC_ALWAYS_ON_HOOK="$SUAC_HOOKS_DIR/shut-up-and-code-always-on.sh"
[ ! -e "$SUAC_ALWAYS_ON_HOOK" ] \
  && ln -fs "$DOTFILES_LLM/hooks/shut-up-and-code-always-on.sh" "$SUAC_ALWAYS_ON_HOOK"
readonly SUAC_AUDIT_HOOK="$SUAC_HOOKS_DIR/shut-up-and-code-audit-on-commit.sh"
[ ! -e "$SUAC_AUDIT_HOOK" ] \
  && ln -fs "$DOTFILES_LLM/hooks/shut-up-and-code-audit-on-commit.sh" "$SUAC_AUDIT_HOOK"

readonly SUAC_FLAG_FILE="$HOME/.claude/.shut-up-and-code-always"
[ ! -e "$SUAC_FLAG_FILE" ] && touch "$SUAC_FLAG_FILE"

readonly SUAC_ALWAYS_ON_COMMAND='bash "$HOME/.claude/hooks/shut-up-and-code-always-on.sh"'
readonly SUAC_AUDIT_COMMAND='bash "$HOME/.claude/hooks/shut-up-and-code-audit-on-commit.sh"'
if ! command -v jq >/dev/null 2>&1; then
  printf "jq not found; skipping shut-up-and-code hook registration.\n"
else
  if jq -e --arg cmd "$SUAC_ALWAYS_ON_COMMAND" \
      '[(.hooks.SessionStart // [])[].hooks[]?.command] | index($cmd)' \
      "$CLAUDE_SETTINGS_FILE" >/dev/null 2>&1; then
    printf "shut-up-and-code always-on hook already registered.\n"
  else
    printf "Registering shut-up-and-code always-on hook on SessionStart...\n"
    settings_tmp="$(mktemp)"
    jq --arg cmd "$SUAC_ALWAYS_ON_COMMAND" \
      '.hooks.SessionStart = ((.hooks.SessionStart // []) + [{
         matcher: "startup|resume|clear|compact",
         hooks: [{ type: "command", command: $cmd, timeout: 5 }]
       }])' "$CLAUDE_SETTINGS_FILE" >"$settings_tmp" \
      && mv -f "$settings_tmp" "$CLAUDE_SETTINGS_FILE" \
      || rm -f "$settings_tmp"
  fi

  if jq -e --arg cmd "$SUAC_AUDIT_COMMAND" \
      '[(.hooks.PreToolUse // [])[].hooks[]?.command] | index($cmd)' \
      "$CLAUDE_SETTINGS_FILE" >/dev/null 2>&1; then
    printf "shut-up-and-code audit-on-commit hook already registered.\n"
  else
    printf "Registering shut-up-and-code audit-on-commit hook on PreToolUse...\n"
    settings_tmp="$(mktemp)"
    jq --arg cmd "$SUAC_AUDIT_COMMAND" \
      '.hooks.PreToolUse = ((.hooks.PreToolUse // []) + [{
         matcher: "Bash",
         hooks: [{ type: "command", command: $cmd, timeout: 5 }]
       }])' "$CLAUDE_SETTINGS_FILE" >"$settings_tmp" \
      && mv -f "$settings_tmp" "$CLAUDE_SETTINGS_FILE" \
      || rm -f "$settings_tmp"
  fi
fi

# An existing statusLine entry is left alone so a machine can keep its own.
printf "Linking status line...\n"
readonly STATUSLINE_DEST="$CLAUDE_CONFIG_DIR/statusline.sh"
[ ! -e "$STATUSLINE_DEST" ] && [ ! -L "$STATUSLINE_DEST" ] \
  && ln -s "$DOTFILES_LLM/statusline.sh" "$STATUSLINE_DEST"
if ! command -v jq >/dev/null 2>&1; then
  printf "jq not found; skipping statusLine registration.\n"
elif jq -e '.statusLine' "$CLAUDE_SETTINGS_FILE" >/dev/null 2>&1; then
  printf "statusLine already configured.\n"
else
  printf "Registering statusLine...\n"
  settings_tmp="$(mktemp)"
  jq '.statusLine = { type: "command", command: "~/.claude/statusline.sh", padding: 1 }' \
    "$CLAUDE_SETTINGS_FILE" >"$settings_tmp" \
    && mv -f "$settings_tmp" "$CLAUDE_SETTINGS_FILE" \
    || rm -f "$settings_tmp"
fi

# Rules are only ever added, so a machine's own allow entries survive.
printf "Merging permission rules...\n"
if ! command -v jq >/dev/null 2>&1; then
  printf "jq not found; skipping permission rules.\n"
else
  settings_tmp="$(mktemp)"
  jq --slurpfile rules "$DOTFILES_LLM/permissions-allow.json" \
    '.permissions.allow = ((.permissions.allow // []) + $rules[0] | unique)' \
    "$CLAUDE_SETTINGS_FILE" >"$settings_tmp" \
    && mv -f "$settings_tmp" "$CLAUDE_SETTINGS_FILE" \
    || rm -f "$settings_tmp"
fi

# Install AutoHarness: a self-learning skill layer that distills skills from
# real sessions. Plugin-installed rather than vendored like visual-pr/retro/etc
# -- it ships a Python backend, an MCP server, and its own hooks, none of which
# a skill-only copy under llm/skills/ would run.
if ! command -v jq >/dev/null 2>&1; then
  printf "jq not found; skipping AutoHarness plugin install.\n"
elif ! command -v claude >/dev/null 2>&1; then
  printf "claude not found; skipping AutoHarness plugin install.\n"
else
  readonly AUTOHARNESS_SOURCE="tigerless-labs/autoharness"
  if claude plugin marketplace list --json 2>/dev/null \
      | jq -e --arg repo "$AUTOHARNESS_SOURCE" '.[] | select(.repo == $repo)' >/dev/null 2>&1; then
    printf "autoharness marketplace already configured.\n"
  else
    printf "Adding autoharness marketplace...\n"
    claude plugin marketplace add "$AUTOHARNESS_SOURCE"
  fi

  if claude plugin list --json 2>/dev/null \
      | jq -e '.[] | select(.id == "autoharness@autoharness")' >/dev/null 2>&1; then
    printf "autoharness plugin already installed.\n"
  else
    printf "Installing autoharness plugin...\n"
    claude plugin install autoharness@autoharness --scope user -y
  fi
fi

printf "Claude Code setup complete.\n"
