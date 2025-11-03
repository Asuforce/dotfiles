#!/bin/bash

set -euo pipefail

# Bootstrap script for dotfiles initial setup
# This script clones the dotfiles repository and runs the complete setup

printf "Starting dotfiles bootstrap...\n\n"

# Detect architecture
UNAME_MACHINE="$(/usr/bin/uname -m)"

if [[ "${UNAME_MACHINE}" == "arm64" ]]; then
  HOMEBREW_PREFIX="/opt/homebrew"
else
  HOMEBREW_PREFIX="/usr/local"
fi

# Create GITHUB_DIR
readonly GITHUB_DIR="$HOME/dev/src/github.com"
if [ ! -d "$GITHUB_DIR" ]; then
  printf "Creating GitHub directory: %s\n" "$GITHUB_DIR"
  mkdir -p "$GITHUB_DIR"
fi

# Clone dotfiles repository
readonly REPO_DIR="$GITHUB_DIR/Asuforce/dotfiles"
if [ ! -d "$REPO_DIR" ]; then
  printf "Cloning dotfiles repository...\n"
  git clone https://github.com/Asuforce/dotfiles.git "$REPO_DIR"
  printf "Repository cloned successfully.\n\n"
else
  printf "Repository already exists at %s\n\n" "$REPO_DIR"
fi

# Change to repository directory
cd "$REPO_DIR"

# Run complete setup using Makefile
printf "Running complete setup via Makefile...\n\n"
make all

# Instructions for user
printf "\n========================================\n"
printf "Setup complete!\n"
printf "========================================\n\n"
printf "To apply shell configuration changes, restart your shell:\n"
printf "  exec \$SHELL -l\n\n"
printf "To run specific setup targets in the future, use:\n"
printf "  make help\n\n"
