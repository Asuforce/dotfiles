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
readonly RUNTIMES=(python@3.12.10 node@lts ruby@3.4.8)

printf "Setting up mise runtimes...\n"
for spec in "${RUNTIMES[@]}"; do
  if [ -f "$MISE_CONFIG_FILE" ] && grep -qE "^${spec%%@*}[[:space:]]*=" "$MISE_CONFIG_FILE"; then
    printf "  skipped, already in mise config: %s\n" "${spec%%@*}"
  else
    mise use -g "$spec"
  fi
done

# Install all tools defined in config.toml
printf "Installing language runtimes...\n"
mise install

printf "Runtime setup complete.\n"
