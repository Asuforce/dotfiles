#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

if ! command -v codex >/dev/null 2>&1; then
  printf "codex not found; skipping Codex config.\n"
  exit 0
fi
if ! python3 -c 'import tomllib' >/dev/null 2>&1; then
  printf "Codex setup requires Python 3.11 or later.\n" >&2
  exit 1
fi

codex_dir="${CODEX_HOME:-$HOME/.codex}"
mkdir -p "$codex_dir/skills"
if [ ! -e "$codex_dir/AGENTS.md" ] && [ ! -L "$codex_dir/AGENTS.md" ]; then
  ln -s "$REPO_DIR/llm/AGENTS.md" "$codex_dir/AGENTS.md"
fi
for skill_dir in "$REPO_DIR"/llm/skills/*/; do
  skill_dest="$codex_dir/skills/$(basename "$skill_dir")"
  if [ ! -e "$skill_dest" ] && [ ! -L "$skill_dest" ]; then
    ln -s "${skill_dir%/}" "$skill_dest"
  fi
done

python3 "$SCRIPT_DIR/codex-config.py" "$REPO_DIR/llm" "$codex_dir"

# Upstream's Codex build lives in the shared user skill directory. Hooks are
# project-local and must be installed and trusted in each project separately.
if [ -f "$HOME/.agents/skills/impeccable/SKILL.md" ]; then
  printf "Impeccable already installed for Codex.\n"
elif ! command -v npx >/dev/null 2>&1; then
  printf "npx not found; skipping Impeccable install.\n"
else
  printf "Installing Impeccable for Codex...\n"
  npx --yes impeccable install --providers=codex --scope=global --no-hooks --yes
fi
printf "Codex setup complete.\n"
