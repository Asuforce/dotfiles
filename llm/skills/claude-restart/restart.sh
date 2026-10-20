#!/usr/bin/env bash
set -euo pipefail

# Restart the herdr panes whose Claude Code is older than the installed one.
# A running claude keeps the binary it started from, so after an auto-update
# every pane stays on the old version until it is restarted. Each idle stale
# pane is stopped and resumed with `claude --resume <session>`, using the
# session id herdr already tracks. Panes that are working or blocked, hold unsent
# input or run background tasks are skipped; run it again once they settle.
#
# Usage: restart.sh [-n]   (-n: only list what would be restarted)

dry_run=0
[ "${1:-}" = "-n" ] && dry_run=1

for cmd in herdr jq; do
  command -v "$cmd" >/dev/null 2>&1 || { printf "%s not found\n" "$cmd" >&2; exit 1; }
done

latest="$(basename "$(readlink "$HOME/.local/bin/claude")")"
printf "Installed Claude Code: %s\n" "$latest"

claude_proc() {
  herdr pane process-info --pane "$1" \
    | jq -c '[.result.process_info.foreground_processes[] | select(.argv0 == "claude")] | first // empty'
}

# Why an idle pane should still be left alone, or nothing. The prompt box sits
# at the bottom, so the last "❯" line is the prompt and the last line is the
# footer, where running background work shows as "· 1 shell". The "← 1 agent"
# segment is always there and is not background work. Dim text in the prompt
# is a suggestion Claude offers, not something typed.
keep_reason() {
  local screen typed footer
  screen="$(herdr pane read "$1" --source visible --format ansi \
    | perl -CSD -pe 's/\e\[2m.*?\e\[[0-9;]*m//g; s/\e\[[0-9;]*m//g; s/\r//g')"
  typed="$(grep '^❯' <<<"$screen" | tail -n 1 \
    | perl -CSD -pe 's/^\x{276f}//; s/[\s\x{a0}]+//g' || true)"
  footer="$(perl -CSD -pe 's/\x{2190} \d+ agents?//' <<<"$screen" \
    | grep -v '^[[:space:]]*$' | tail -n 1)"
  if [ -n "$typed" ]; then
    echo "unsent input"
  elif grep -qE '· [0-9]+ [[:alpha:]]' <<<"$footer"; then
    echo "background tasks"
  fi
}

while IFS=$'\t' read -r pane status session; do
  proc="$(claude_proc "$pane")"
  version="$(jq -r '.name // empty' <<<"$proc")"
  [ -n "$version" ] && [ "$version" != "$latest" ] || continue

  if [ "$status" != idle ] || [ -z "$session" ]; then
    printf "  skip    %s (%s, %s)\n" "$pane" "$version" "$([ -n "$session" ] && echo "$status" || echo "no session id")"
    continue
  fi
  if reason="$(keep_reason "$pane")" && [ -n "$reason" ]; then
    printf "  skip    %s (%s, %s)\n" "$pane" "$version" "$reason"
    continue
  fi
  printf "  restart %s (%s -> %s)\n" "$pane" "$version" "$latest"
  [ "$dry_run" = 1 ] && continue

  args=(--resume "$session")
  jq -e '.argv // [] | index("--dangerously-skip-permissions")' <<<"$proc" >/dev/null \
    && args=(--dangerously-skip-permissions "${args[@]}")

  # `/exit` only moves the conversation to the background, so signal it.
  kill -TERM "$(jq -r '.pid' <<<"$proc")"
  for _ in $(seq 30); do
    [ -z "$(claude_proc "$pane")" ] && break
    sleep 1
  done
  name="claude-$(tr 'A-Z:' 'a-z-' <<<"$pane")"
  herdr agent start "$name" --kind claude --pane "$pane" -- "${args[@]}" >/dev/null
done < <(herdr pane list \
  | jq -r '.result.panes[] | select(.agent == "claude")
           | [.pane_id, .agent_status, (.agent_session.value // "")] | @tsv')
