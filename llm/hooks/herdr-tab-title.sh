#!/usr/bin/env bash
# [Stop] Name the herdr tab after the task the session is working on.
#
# Claude Code writes an AI-generated session title ("ai-title") into the
# transcript after the first turn, so the name costs no extra model call and
# nothing has to be derived from the raw prompt. This hook copies that title
# onto the tab label and follows it when Claude Code revises it.
#
# Prints nothing and fails open.
set -u

MAX_CHARS=24

[ "${HERDR_ENV:-}" = 1 ] && [ -n "${HERDR_TAB_ID:-}" ] || exit 0
command -v herdr >/dev/null 2>&1 || exit 0
command -v jq >/dev/null 2>&1 || exit 0

input="$(cat 2>/dev/null || true)"
session_id="$(jq -r '.session_id // empty' <<<"$input" 2>/dev/null)"
transcript="$(jq -r '.transcript_path // empty' <<<"$input" 2>/dev/null)"
[ -n "$session_id" ] && [ -r "$transcript" ] || exit 0

title="$(grep -F '"type":"ai-title"' "$transcript" | tail -1 | jq -r '.aiTitle // empty' 2>/dev/null)"
[ -n "$title" ] || exit 0
# jq counts code points, so Japanese titles are cut by characters, not bytes.
label="$(jq -rn --arg t "$title" --argjson n "$MAX_CHARS" \
  'if ($t | length) > $n then $t[0:$n - 1] + "…" else $t end')"

current="$(herdr tab get "$HERDR_TAB_ID" 2>/dev/null | jq -r '.result.tab.label // empty')"
[ -n "$current" ] && [ "$current" != "$label" ] || exit 0

# herdr numbers unnamed tabs ("1", "2", ...). Any other label is either one the
# user typed or one another pane's session claimed, and neither gets overwritten.
# The one exception is this session's own earlier title, which moves with it.
state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/herdr-tab-title"
state_file="$state_dir/$session_id"
applied="$(cat "$state_file" 2>/dev/null || true)"
case "$current" in
  *[!0-9]*) [ -n "$applied" ] && [ "$current" = "$applied" ] || exit 0 ;;
esac

herdr tab rename "$HERDR_TAB_ID" "$label" >/dev/null 2>&1 || exit 0
mkdir -p "$state_dir" && printf '%s' "$label" >"$state_file"
exit 0
