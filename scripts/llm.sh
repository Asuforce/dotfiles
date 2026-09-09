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

# Link commands directory
readonly CLAUDE_COMMANDS_DIR="$CLAUDE_CONFIG_DIR/commands"
[ ! -e "$CLAUDE_COMMANDS_DIR" ] && ln -fs "$DOTFILES_LLM/commands" "$CLAUDE_COMMANDS_DIR"

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
else
  printf "herdr not found; skipping herdr skill and integration.\n"
fi

printf "Claude Code setup complete.\n"
