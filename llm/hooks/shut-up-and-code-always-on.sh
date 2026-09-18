#!/usr/bin/env bash
# [SessionStart] Inject the full shut-up-and-code ruleset into context at the
# start of every session (startup, resume, clear, compact), instead of relying
# on the model to invoke the skill on its own each time it writes code. Gated
# on ~/.claude/.shut-up-and-code-always so it stays opt-in and easy to turn
# off; create the flag file to enable it, delete it to disable.
# Never blocks session start: any failure exits 0.
#
# Adapted from https://github.com/chl03ks/shut-up-and-code hooks/always-on.sh
set -u

claude_dir="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
flag_path="$claude_dir/.shut-up-and-code-always"
[ -f "$flag_path" ] || exit 0

skill_path="$claude_dir/skills/shut-up-and-code/SKILL.md"
[ -f "$skill_path" ] || exit 0

# Strip the leading YAML frontmatter block; print the rest unchanged.
body="$(awk '
  NR == 1 && /^---[[:space:]]*$/ { in_fm = 1; next }
  in_fm && /^---[[:space:]]*$/   { in_fm = 0; next }
  in_fm                          { next }
  { print }
' "$skill_path")"

printf 'SHUT UP AND CODE ACTIVE (always-on). The ruleset below applies to every file you write or edit. Say "normal comments" to turn it off for this session; delete %s to turn always-on off for good.\n\n%s\n' \
  "$flag_path" "$body"
