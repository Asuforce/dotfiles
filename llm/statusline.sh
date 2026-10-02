#!/bin/bash
input=$(cat)
model=$(echo "$input" | jq -r '.model.display_name // "Unknown"')
context_pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0')
workspace=$(echo "$input" | jq -r '.workspace.current_dir // ""')
cost=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
rate_5h=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty' 2>/dev/null || echo "")
rate_7d=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty' 2>/dev/null || echo "")

ws_name="--"
[[ -n "$workspace" ]] && ws_name=$(basename "$workspace")
branch=$(git -C "$workspace" branch --show-current 2>/dev/null || echo "--")
branch="${branch:-"--"}"

color_for_pct() {
  local pct="$1"
  [[ -z "$pct" || "$pct" == "null" ]] && { echo "\033[0m"; return; }
  local int_pct="${pct%.*}"
  if (( int_pct >= 90 )); then echo "\033[31m"
  elif (( int_pct >= 70 )); then echo "\033[33m"
  else echo "\033[32m"; fi
}
RESET="\033[0m"

context_int="${context_pct%.*}"
filled=$(( context_int / 10 )); empty=$(( 10 - filled ))
bar=""
for (( i=0; i<filled; i++ )); do bar+="●"; done
for (( i=0; i<empty; i++ )); do bar+="○"; done
context_color=$(color_for_pct "$context_int")

if [[ -n "$rate_5h" && "$rate_5h" != "null" ]]; then
  rate_5h_int="${rate_5h%.*}"; rate_5h_color=$(color_for_pct "$rate_5h_int")
  rate_5h_display="${rate_5h_color}${rate_5h_int}%${RESET}"
else rate_5h_display="--"; fi

if [[ -n "$rate_7d" && "$rate_7d" != "null" ]]; then
  rate_7d_int="${rate_7d%.*}"; rate_7d_color=$(color_for_pct "$rate_7d_int")
  rate_7d_display="${rate_7d_color}${rate_7d_int}%${RESET}"
else rate_7d_display="--"; fi

cost_display=$(printf '$%.2f' "$cost")
echo -e "${model} ▸ ${ws_name} ⎇ ${branch}"
echo -e "${context_color}${bar}${RESET} ${context_int}% ▸ 5h: ${rate_5h_display} ▸ 7d: ${rate_7d_display} ▸ ${cost_display}"
