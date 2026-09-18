#!/usr/bin/env bash
# [PreToolUse:Bash] Re-inject the shut-up-and-code audit-point reminder right
# before a git commit, so it still fires once SKILL.md has scrolled far back in
# a long session's context. Opt-in via the same ~/.claude/.shut-up-and-code-always
# flag the SessionStart hook checks.
# Never blocks the commit: any failure exits 0.
#
# Adapted from https://github.com/chl03ks/shut-up-and-code hooks/audit-on-commit.mjs
set -u

flag_path="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/.shut-up-and-code-always"
[ -f "$flag_path" ] || exit 0
command -v jq >/dev/null 2>&1 || exit 0

input="$(cat 2>/dev/null || true)"
command="$(jq -r '.tool_input.command // empty' <<<"$input" 2>/dev/null)" || exit 0
[[ "$command" =~ (^|[^a-zA-Z0-9_-])git([[:space:]]+[a-zA-Z0-9_.=-]+)*[[:space:]]+commit([^a-zA-Z0-9_-]|$) ]] || exit 0

jq -n '{
  hookSpecificOutput: {
    hookEventName: "PreToolUse",
    permissionDecision: "allow",
    additionalContext: "shut-up-and-code audit point: account for every comment in this diff — per clause, test names included — before this commit lands."
  }
}'
