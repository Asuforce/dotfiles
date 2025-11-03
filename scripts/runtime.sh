#!/bin/bash

set -euo pipefail

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

UNAME_MACHINE="$(/usr/bin/uname -m)"

if [[ "${UNAME_MACHINE}" == "arm64" ]]; then
  BREW_DIR="/opt/homebrew"
else
  BREW_DIR="/usr/local"
fi

readonly BREW=$BREW_DIR/bin/brew

# Install mise if not already installed
if ! type mise > /dev/null 2>&1; then
  printf "Installing mise...\n"
  "$BREW" install mise
fi

# Setup mise configuration
printf "Setting up mise configuration...\n"

readonly MISE_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/mise"
if [ ! -d "$MISE_CONFIG_DIR" ]; then
  mkdir -p "$MISE_CONFIG_DIR"
fi

readonly MISE_CONFIG_FILE="$MISE_CONFIG_DIR/config.toml"
if [ ! -e "$MISE_CONFIG_FILE" ]; then
  ln -fs "$REPO_DIR/runtime/config.toml" "$MISE_CONFIG_FILE"
fi

# Install all tools defined in config.toml
printf "Installing language runtimes...\n"
mise install

printf "Runtime setup complete.\n"
