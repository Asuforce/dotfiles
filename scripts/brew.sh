#!/bin/bash

set -euo pipefail

UNAME_MACHINE="$(/usr/bin/uname -m)"

if [[ "${UNAME_MACHINE}" == "arm64" ]]; then
  BREW_DIR="/opt/homebrew"
else
  BREW_DIR="/usr/local"
fi

readonly BREW=$BREW_DIR/bin/brew

# Install Homebrew
if ! type "$BREW" > /dev/null 2>&1; then
  printf "Installing Homebrew...\n"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

# Install applications from Brewfile
printf "Installing packages from Brewfile...\n"
cd "$REPO_DIR"
"$BREW" bundle

# Install gh extensions
readonly GH="$BREW_DIR/bin/gh"
if type "$GH" > /dev/null 2>&1; then
  if ! "$GH" extension list | grep -q "seachicken/gh-poi"; then
    printf "Installing gh-poi extension...\n"
    "$GH" extension install seachicken/gh-poi
  fi
fi

# Install rustup
if ! type rustup > /dev/null 2>&1; then
  printf "Installing Rustup...\n"
  curl https://sh.rustup.rs -sSf | sh -s -- -y
fi

printf "Homebrew setup complete.\n"
