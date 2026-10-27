#!/bin/bash

set -euo pipefail

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

# mise ships in omarchy's base packages, so only macOS installs it here.
if ! type mise > /dev/null 2>&1; then
  if [[ "$(uname -s)" != "Darwin" ]]; then
    printf "mise not found; install the mise-bin package first.\n" >&2
    exit 1
  fi

  if [[ "$(uname -m)" == "arm64" ]]; then
    BREW_DIR="/opt/homebrew"
  else
    BREW_DIR="/usr/local"
  fi

  printf "Installing mise...\n"
  "$BREW_DIR/bin/brew" install mise
fi

# mise owns ~/.config/mise/config.toml, as on omarchy: omarchy seeds it and its
# own tooling edits it, so it is not linked from the repo. Each runtime below is
# added with `mise use -g` only when the file does not name it yet, which keeps
# whatever version omarchy (or the user) already chose.
readonly MISE_CONFIG_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/mise/config.toml"
# Languages follow lts where mise has that alias (node) and latest otherwise,
# since python and ruby publish no lts.
RUNTIMES=(python@latest node@lts ruby@latest uv@latest pypi:graphifyy@latest)
# gcloud and go-jsonnet are mise-managed on Linux only; macOS gets them outside
# mise (the former outside this repo, the latter from the Brewfile).
if [[ "$(uname -s)" != "Darwin" ]]; then
  RUNTIMES+=(gcloud@latest go-jsonnet@latest)
fi

printf "Setting up mise runtimes...\n"
for spec in "${RUNTIMES[@]}"; do
  # Backend-prefixed names such as pypi:graphifyy are written as quoted keys.
  if [ -f "$MISE_CONFIG_FILE" ] && grep -qE "^\"?${spec%%@*}\"?[[:space:]]*=" "$MISE_CONFIG_FILE"; then
    printf "  skipped, already in mise config: %s\n" "${spec%%@*}"
  else
    mise use -g "$spec"
  fi
done

# Install all tools defined in config.toml
printf "Installing language runtimes...\n"
mise install

# graphify copies its skill rather than being linked, so this runs on every
# pass to pick up upgrades. It lives here, not in llm.sh, because `make all`
# runs llm before runtime and the CLI would not exist yet on a fresh machine.
# The Claude install also appends a block to ~/.claude/CLAUDE.md, a link to the
# tracked llm/AGENTS.md, so it runs against a scratch CLAUDE_CONFIG_DIR and only
# the skill is moved into place; Claude Code finds it from its frontmatter.
if graphify_bin="$(mise which graphify 2>/dev/null)"; then
  printf "Installing graphify skills...\n"
  graphify_tmp="$(mktemp -d)"
  CLAUDE_CONFIG_DIR="$graphify_tmp" "$graphify_bin" install >/dev/null
  mkdir -p "$HOME/.claude/skills"
  rm -rf "$HOME/.claude/skills/graphify"
  mv "$graphify_tmp/skills/graphify" "$HOME/.claude/skills/graphify"
  rm -rf "$graphify_tmp"
  if command -v codex >/dev/null 2>&1; then
    "$graphify_bin" install --platform codex >/dev/null
  fi

  # The PreToolUse hooks `graphify claude install` would put in a project's
  # .claude/settings.json, registered user-wide instead: the guard prints
  # nothing unless ./graphify-out/graph.json exists, so other repos see no
  # change. The bare command resolves through the mise shim, which survives
  # graphify upgrades where the absolute path would not.
  readonly CLAUDE_SETTINGS_FILE="$HOME/.claude/settings.json"
  if ! command -v jq >/dev/null 2>&1 || [ ! -f "$CLAUDE_SETTINGS_FILE" ]; then
    printf "jq or Claude settings not found; skipping graphify hooks.\n"
  else
    for guard in "Bash|Grep:search" "Read|Glob:read"; do
      matcher="${guard%%:*}"
      command="graphify hook-guard ${guard##*:}"
      if jq -e --arg cmd "$command" \
          '[(.hooks.PreToolUse // [])[].hooks[]?.command] | index($cmd)' \
          "$CLAUDE_SETTINGS_FILE" >/dev/null 2>&1; then
        continue
      fi
      printf "Registering graphify %s hook on PreToolUse...\n" "${guard##*:}"
      settings_tmp="$(mktemp)"
      jq --arg matcher "$matcher" --arg cmd "$command" \
        '.hooks.PreToolUse = ((.hooks.PreToolUse // []) + [{
           matcher: $matcher,
           hooks: [{ type: "command", command: $cmd, timeout: 10 }]
         }])' "$CLAUDE_SETTINGS_FILE" >"$settings_tmp" \
        && mv -f "$settings_tmp" "$CLAUDE_SETTINGS_FILE" \
        || rm -f "$settings_tmp"
    done
  fi
else
  printf "graphify not found; skipping graphify skills.\n"
fi

printf "Runtime setup complete.\n"
