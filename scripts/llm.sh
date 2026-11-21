#!/bin/bash

set -euo pipefail

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

# A brew-style "==>" section heading, bold blue on a terminal.
heading() {
  if [ -t 1 ]; then
    printf "\033[1;34m==>\033[0m \033[1m%s\033[0m\n" "$1"
  else
    printf "==> %s\n" "$1"
  fi
}

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

  printf "Linking herdr tab-title hook...\n"
  readonly TAB_TITLE_HOOK="$CLAUDE_HOOKS_DIR/herdr-tab-title.sh"
  [ ! -e "$TAB_TITLE_HOOK" ] \
    && ln -fs "$DOTFILES_LLM/hooks/herdr-tab-title.sh" "$TAB_TITLE_HOOK"

  readonly TAB_TITLE_HOOK_COMMAND='bash "$HOME/.claude/hooks/herdr-tab-title.sh"'
  if ! command -v jq >/dev/null 2>&1; then
    printf "jq not found; skipping Stop hook registration.\n"
  elif jq -e --arg cmd "$TAB_TITLE_HOOK_COMMAND" \
      '[(.hooks.Stop // [])[].hooks[]?.command] | index($cmd)' \
      "$CLAUDE_SETTINGS_FILE" >/dev/null 2>&1; then
    printf "herdr tab-title hook already registered.\n"
  else
    printf "Registering herdr tab-title hook on Stop...\n"
    settings_tmp="$(mktemp)"
    jq --arg cmd "$TAB_TITLE_HOOK_COMMAND" \
      '.hooks.Stop = ((.hooks.Stop // []) + [{
         hooks: [{ type: "command", command: $cmd, timeout: 10 }]
       }])' "$CLAUDE_SETTINGS_FILE" >"$settings_tmp" \
      && mv -f "$settings_tmp" "$CLAUDE_SETTINGS_FILE" \
      || rm -f "$settings_tmp"
  fi

  # The same script resets the tab label on /clear. It has to be its own
  # SessionStart entry because the Stop entry above carries no matcher.
  if command -v jq >/dev/null 2>&1 && ! jq -e --arg cmd "$TAB_TITLE_HOOK_COMMAND" \
      '[(.hooks.SessionStart // [])[] | select(.matcher == "clear") | .hooks[]?.command] | index($cmd)' \
      "$CLAUDE_SETTINGS_FILE" >/dev/null 2>&1; then
    printf "Registering herdr tab-title hook on SessionStart (clear)...\n"
    settings_tmp="$(mktemp)"
    jq --arg cmd "$TAB_TITLE_HOOK_COMMAND" \
      '.hooks.SessionStart = ((.hooks.SessionStart // []) + [{
         matcher: "clear",
         hooks: [{ type: "command", command: $cmd, timeout: 10 }]
       }])' "$CLAUDE_SETTINGS_FILE" >"$settings_tmp" \
      && mv -f "$settings_tmp" "$CLAUDE_SETTINGS_FILE" \
      || rm -f "$settings_tmp"
  fi
else
  printf "herdr not found; skipping herdr skill and integration.\n"
fi

# ctxdb distills finished sessions into SQLite and injects only the stored
# notes a prompt matches. One script serves all three events, keyed on
# hook_event_name.
printf "Linking ctxdb hook...\n"
mkdir -p "$CLAUDE_CONFIG_DIR/hooks"
readonly CTXDB_HOOK="$CLAUDE_CONFIG_DIR/hooks/ctxdb.py"
[ ! -e "$CTXDB_HOOK" ] && [ ! -L "$CTXDB_HOOK" ] \
  && ln -s "$DOTFILES_LLM/hooks/ctxdb.py" "$CTXDB_HOOK"
readonly CTXDB_HOOK_COMMAND='python3 "$HOME/.claude/hooks/ctxdb.py"'
if ! command -v jq >/dev/null 2>&1; then
  printf "jq not found; skipping ctxdb hook registration.\n"
else
  for event in SessionEnd UserPromptSubmit SessionStart; do
    if jq -e --arg ev "$event" --arg cmd "$CTXDB_HOOK_COMMAND" \
        '[(.hooks[$ev] // [])[].hooks[]?.command] | index($cmd)' \
        "$CLAUDE_SETTINGS_FILE" >/dev/null 2>&1; then
      continue
    fi
    printf "Registering ctxdb hook on %s...\n" "$event"
    settings_tmp="$(mktemp)"
    jq --arg ev "$event" --arg cmd "$CTXDB_HOOK_COMMAND" \
      '.hooks[$ev] = ((.hooks[$ev] // []) + [{
         hooks: [{ type: "command", command: $cmd, timeout: 10 }]
       }])' "$CLAUDE_SETTINGS_FILE" >"$settings_tmp" \
      && mv -f "$settings_tmp" "$CLAUDE_SETTINGS_FILE" \
      || rm -f "$settings_tmp"
  done
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

# Codex shares the instructions and skills, with its own runtime settings.
bash "$SCRIPT_DIR/codex.sh"

# Antigravity shares compatible skills from llm/skills/.
bash "$SCRIPT_DIR/antigravity.sh"

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

# Unbinds ctrl+g, which is herdr's prefix.
printf "Linking keybindings...\n"
readonly KEYBINDINGS_DEST="$CLAUDE_CONFIG_DIR/keybindings.json"
[ ! -e "$KEYBINDINGS_DEST" ] && [ ! -L "$KEYBINDINGS_DEST" ] \
  && ln -s "$DOTFILES_LLM/keybindings.json" "$KEYBINDINGS_DEST"

# omarchy only: the sudoers file that makes these targets promptless is Linux's.
# Rules are only ever added, so a machine's own allow entries survive.
printf "Merging permission rules...\n"
if [[ "$(uname -s)" != "Linux" ]]; then
  printf "Not Linux; skipping permission rules.\n"
elif ! command -v jq >/dev/null 2>&1; then
  printf "jq not found; skipping permission rules.\n"
else
  settings_tmp="$(mktemp)"
  jq --slurpfile rules "$DOTFILES_LLM/permissions-allow.json" \
    '.permissions.allow = ((.permissions.allow // []) + $rules[0] | unique)' \
    "$CLAUDE_SETTINGS_FILE" >"$settings_tmp" \
    && mv -f "$settings_tmp" "$CLAUDE_SETTINGS_FILE" \
    || rm -f "$settings_tmp"
fi

# mattpocock-skills ships its own code-review; hide the bundled one so the two
# do not compete. skillOverrides leaves plugin skills alone. A machine that
# already set the key keeps its value.
printf "Hiding bundled code-review skill...\n"
if ! command -v jq >/dev/null 2>&1; then
  printf "jq not found; skipping skill overrides.\n"
elif jq -e '.skillOverrides["code-review"]' "$CLAUDE_SETTINGS_FILE" >/dev/null 2>&1; then
  printf "code-review override already set.\n"
else
  settings_tmp="$(mktemp)"
  jq '.skillOverrides["code-review"] = "off"' \
    "$CLAUDE_SETTINGS_FILE" >"$settings_tmp" \
    && mv -f "$settings_tmp" "$CLAUDE_SETTINGS_FILE" \
    || rm -f "$settings_tmp"
fi

# pstack's own session hook defers to CLAUDE.md, so the precedence has to be
# written on the user's side.
printf "Linking pstack priority rules...\n"
mkdir -p "$CLAUDE_CONFIG_DIR/rules"
for rule in pstack-priority pstack-codex; do
  rule_dest="$CLAUDE_CONFIG_DIR/rules/$rule.md"
  if [ -L "$rule_dest" ] && [ ! -e "$rule_dest" ]; then
    rm -f "$rule_dest"
  fi
  [ ! -e "$rule_dest" ] && [ ! -L "$rule_dest" ] \
    && ln -s "$DOTFILES_LLM/$rule.md" "$rule_dest"
done

# Plugin-installed rather than vendored like show-me/yomiyasu/etc: each ships
# hooks, an MCP server or a backend that a skill-only copy under llm/skills/
# would not run.
readonly PLUGINS_MANIFEST="$DOTFILES_LLM/plugins.tsv"
if ! command -v jq >/dev/null 2>&1; then
  printf "jq not found; skipping plugin install.\n"
elif ! command -v claude >/dev/null 2>&1; then
  printf "claude not found; skipping plugin install.\n"
else
  # Refresh catalogs first so plugin update sees upstream's latest versions.
  heading "Updating plugin marketplaces"
  claude plugin marketplace update </dev/null \
    || printf "Some marketplaces could not be refreshed; continuing.\n"
  plugin_version() {
    jq -er --arg id "$2" '.[] | select(.id == $id) | .version' <<<"$1" 2>/dev/null
  }
  plugins_before="$(claude plugin list --json 2>/dev/null || echo '[]')"
  managed_plugins=()
  new_plugins=()
  failed_plugins=()
  while IFS=$'\t' read -r source plugin only_os || [ -n "${plugin:-}" ]; do
    case "$source" in '' | '#'*) continue ;; esac
    if [ -n "${only_os:-}" ] && [ "$only_os" != "$(uname -s)" ]; then
      printf "%s is %s only; skipping.\n" "$plugin" "$only_os"
      continue
    fi
    if [ "$source" = "-" ]; then
      # Built-in plugins are not in claude plugin list, so check the setting.
      if jq -e --arg id "$plugin" '.enabledPlugins[$id] == true' "$CLAUDE_SETTINGS_FILE" >/dev/null 2>&1; then
        printf "%s already enabled.\n" "$plugin"
      else
        printf "Enabling %s...\n" "$plugin"
        claude plugin enable "$plugin" </dev/null
      fi
      continue
    fi

    # Match by catalog name, not repo: a machine may have registered the same
    # catalog from an older source, and re-adding it would fail.
    marketplace="${plugin#*@}"
    registered_repo="$(claude plugin marketplace list --json 2>/dev/null \
      | jq -r --arg name "$marketplace" '.[] | select(.name == $name) | .repo' 2>/dev/null)"
    if [ -z "$registered_repo" ]; then
      printf "Adding marketplace %s...\n" "$source"
      claude plugin marketplace add "$source" </dev/null
    elif [ "$registered_repo" != "$source" ]; then
      printf "Marketplace %s is registered from %s, not %s; keeping it.\n" \
        "$marketplace" "$registered_repo" "$source"
    fi

    if plugin_version "$plugins_before" "$plugin" >/dev/null; then
      # Update output is the same "already latest" line on most runs, so it is
      # shown only on failure; the summary below reports what changed.
      if ! update_log="$(claude plugin update "$plugin" --scope user -y </dev/null 2>&1)"; then
        printf "%s\n" "$update_log"
        failed_plugins+=("$plugin")
      fi
    else
      printf "Installing %s...\n" "$plugin"
      claude plugin install "$plugin" --scope user -y </dev/null
      new_plugins+=("$plugin")
    fi
    managed_plugins+=("$plugin")
  done <"$PLUGINS_MANIFEST"

  # Summarize like `brew upgrade`: what was installed, what moved, what failed.
  plugins_after="$(claude plugin list --json 2>/dev/null || echo '[]')"
  upgraded_lines=()
  for plugin in "${managed_plugins[@]+"${managed_plugins[@]}"}"; do
    before="$(plugin_version "$plugins_before" "$plugin" || true)"
    after="$(plugin_version "$plugins_after" "$plugin" || true)"
    if [ -n "$before" ] && [ -n "$after" ] && [ "$before" != "$after" ]; then
      upgraded_lines+=("$plugin $before -> $after")
    fi
  done
  if [ "${#new_plugins[@]}" -gt 0 ]; then
    heading "Installed ${#new_plugins[@]} plugin(s)"
    for plugin in "${new_plugins[@]}"; do
      printf "%s %s\n" "$plugin" "$(plugin_version "$plugins_after" "$plugin" || echo '?')"
    done
  fi
  if [ "${#upgraded_lines[@]}" -gt 0 ]; then
    heading "Upgraded ${#upgraded_lines[@]} plugin(s)"
    printf "%s\n" "${upgraded_lines[@]}"
  fi
  if [ "${#failed_plugins[@]}" -gt 0 ]; then
    heading "Failed to update ${#failed_plugins[@]} plugin(s)"
    printf "%s\n" "${failed_plugins[@]}"
  fi
  if [ "${#new_plugins[@]}" -eq 0 ] && [ "${#upgraded_lines[@]}" -eq 0 ] \
      && [ "${#failed_plugins[@]}" -eq 0 ]; then
    heading "All ${#managed_plugins[@]} plugin(s) up to date"
  else
    printf "Restart Claude Code to load the changes.\n"
  fi
fi

# OAuth keys and tokens stay outside the repository.
if [[ "$(uname -s)" == "Linux" ]] && command -v claude >/dev/null 2>&1; then
  if ! claude mcp get gdrive >/dev/null 2>&1; then
    claude mcp add --scope user gdrive -- bash "$SCRIPT_DIR/mcp-gdrive.sh"
  fi
fi

printf "Claude Code setup complete.\n"
