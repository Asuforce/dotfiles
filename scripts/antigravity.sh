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

ensure_gdrive_mcp() {
  local config_path="$1"
  local tmp_file
  mkdir -p "$(dirname "$config_path")"
  tmp_file="$(mktemp "${config_path}.XXXXXX")"
  if [ -s "$config_path" ]; then
    jq --arg script "$SCRIPT_DIR/mcp-gdrive.sh" \
      '.mcpServers = ((.mcpServers // {}) + {gdrive: {command: "bash", args: [$script]}})' \
      "$config_path" >"$tmp_file"
  else
    jq -n --arg script "$SCRIPT_DIR/mcp-gdrive.sh" \
      '{mcpServers: {gdrive: {command: "bash", args: [$script]}}}' >"$tmp_file"
  fi
  mv "$tmp_file" "$config_path"
}

if [[ "$(uname -s)" == "Linux" ]] && command -v jq >/dev/null 2>&1; then
  ensure_gdrive_mcp "$gemini_config_dir/mcp_config.json"
  if [ -z "${GEMINI_CONFIG_DIR:-}" ]; then
    for t3_config_dir in "$HOME"/.t3/userdata/providers/antigravity/*/config; do
      [ -d "$t3_config_dir" ] || continue
      ensure_gdrive_mcp "$t3_config_dir/mcp_config.json"
    done
  fi
fi

printf "Antigravity setup complete.\n"
