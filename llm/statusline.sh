#!/bin/bash
input=$(cat)
model=$(echo "$input" | jq -r '.model.display_name // "Unknown"')
workspace=$(echo "$input" | jq -r '.workspace.current_dir // ""')

ws_name="--"
[[ -n "$workspace" ]] && ws_name=$(basename "$workspace")
branch=$(git -C "$workspace" branch --show-current 2>/dev/null || echo "--")
branch="${branch:-"--"}"

echo "${model} ▸ ${ws_name} ⎇ ${branch}"
