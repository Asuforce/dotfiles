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

# Link settings.json
readonly CLAUDE_SETTINGS_FILE="$CLAUDE_CONFIG_DIR/settings.json"
[ ! -e "$CLAUDE_SETTINGS_FILE" ] && ln -fs "$DOTFILES_LLM/settings.json" "$CLAUDE_SETTINGS_FILE"

# Link commands directory
readonly CLAUDE_COMMANDS_DIR="$CLAUDE_CONFIG_DIR/commands"
[ ! -e "$CLAUDE_COMMANDS_DIR" ] && ln -fs "$DOTFILES_LLM/commands" "$CLAUDE_COMMANDS_DIR"

printf "Claude Code setup complete.\n"
