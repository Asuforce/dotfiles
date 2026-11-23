#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

gemini_config_dir="${GEMINI_CONFIG_DIR:-$HOME/.gemini/config}"
if [ ! -d "$gemini_config_dir" ] && ! command -v agy >/dev/null 2>&1 && ! command -v antigravity >/dev/null 2>&1; then
  printf "antigravity not found; skipping Antigravity config.\n"
  exit 0
fi

# Per-skill symlinks into ~/.gemini/config/skills/ instead of skills.json:
# omarchy populates that directory with its own skill links, and harnesses like
# T3 Code symlink only config/skills rather than the parent config directory.
skills_dir="$gemini_config_dir/skills"
mkdir -p "$skills_dir"

for skill_dir in "$REPO_DIR"/llm/skills/*/; do
  skill_name="$(basename "$skill_dir")"
  case "$skill_name" in
  # Claude Code specific (MEMORY.md / /compact, ~/.claude/sessions, marketplace paths).
  before-compact | claude-restart | chief-of-staff)
    continue
    ;;
  esac
  skill_dest="$skills_dir/$skill_name"
  if [ ! -e "$skill_dest" ] && [ ! -L "$skill_dest" ]; then
    ln -s "${skill_dir%/}" "$skill_dest"
  fi
done

printf "Antigravity setup complete.\n"
