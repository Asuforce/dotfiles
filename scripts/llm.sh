#!/bin/bash

set -euo pipefail

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

# Link Claude Code config
printf "Setting up Claude Code configuration...\n"

readonly CLAUDE_CONFIG_DIR="$HOME/.claude"
[ ! -d "$CLAUDE_CONFIG_DIR" ] && mkdir -p "$CLAUDE_CONFIG_DIR"

readonly DOTFILES_LLM="$REPO_DIR/llm"

# Link CLAUDE.md (AGENTS.md)
readonly CLAUDE_AGENTS_FILE="$CLAUDE_CONFIG_DIR/CLAUDE.md"
[ ! -e "$CLAUDE_AGENTS_FILE" ] && ln -fs "$DOTFILES_LLM/AGENTS.md" "$CLAUDE_AGENTS_FILE"

# Copy settings.json
readonly CLAUDE_SETTINGS_FILE="$CLAUDE_CONFIG_DIR/settings.json"
[ ! -e "$CLAUDE_SETTINGS_FILE" ] && cp "$DOTFILES_LLM/settings.json" "$CLAUDE_SETTINGS_FILE"

# Link skills directory
readonly CLAUDE_SKILLS_DIR="$CLAUDE_CONFIG_DIR/skills"
[ ! -e "$CLAUDE_SKILLS_DIR" ] && ln -fs "$DOTFILES_LLM/skills" "$CLAUDE_SKILLS_DIR"

# Set up herdr as the substrate for agent work
if command -v herdr >/dev/null 2>&1; then
  # Regenerate the herdr skill from the installed binary so it tracks herdr
  # upgrades. The output is git-ignored: it is generated, not hand-written.
  printf "Generating herdr skill...\n"
  readonly HERDR_SKILL_DIR="$DOTFILES_LLM/skills/herdr"
  [ ! -d "$HERDR_SKILL_DIR" ] && mkdir -p "$HERDR_SKILL_DIR"
  herdr --skill >"$HERDR_SKILL_DIR/SKILL.md"

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
  # `herdr integration install claude` writes, so it is merged in with jq rather
  # than carried in llm/settings.json (which is only copied on a fresh machine).
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

printf "Claude Code setup complete.\n"
