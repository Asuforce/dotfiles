#!/usr/bin/env bash
# [SessionStart] Keep herdr at "one repository = one workspace = side-by-side worktrees".
#
# Starting Claude in the same repository otherwise spawns a new workspace every
# time, and `herdr worktree` puts each linked worktree in its own workspace. On
# startup this hook moves the calling pane into the existing workspace for the
# same repository, or renames the current workspace after the repository when
# there is none yet. Grouping is keyed on the shared .git directory, so linked
# worktrees land next to their main checkout.
#
# SessionStart output is fed to the model, so this prints nothing. Anything it
# cannot decide is left alone (fail-open).
#
# Adapted from https://zenn.dev/gemcook/articles/herdr-worktree-parallel
set -u

# Columns to lay out side by side, and the minimum width per column. A pane
# that would break either limit stays in the workspace herdr opened it in.
# Splitting further down is not an option: short panes are unreadable.
MAX_COLUMNS=3
MIN_COLS=50

[ "${HERDR_ENV:-}" = 1 ] || exit 0
[ -n "${HERDR_PANE_ID:-}" ] && [ -n "${HERDR_WORKSPACE_ID:-}" ] || exit 0
command -v herdr >/dev/null 2>&1 || exit 0
command -v jq >/dev/null 2>&1 || exit 0

input="$(cat 2>/dev/null || true)"
# resume / clear / compact run in a pane that is already placed; leave it alone.
[ "$(jq -r '.source // "startup"' <<<"$input" 2>/dev/null)" = startup ] || exit 0

cwd="$(jq -r '.cwd // empty' <<<"$input" 2>/dev/null)"
[ -n "$cwd" ] || cwd="$PWD"

# Name the repository after the shared .git so a worktree resolves to the same
# name as its main checkout.
repo_name_of() {
  local dir="$1" common name
  [ -d "$dir" ] || return 1
  common="$(git -C "$dir" rev-parse --path-format=absolute --git-common-dir 2>/dev/null)" \
    || common="$(git -C "$dir" rev-parse --show-toplevel 2>/dev/null)/.git"
  [ -n "$common" ] && [ "$common" != "/.git" ] || return 1
  name="$(basename "$(dirname "${common%/}")")"
  [ -n "$name" ] && [ "$name" != / ] || return 1
  printf '%s' "$name"
}

repo="$(repo_name_of "$cwd")" || exit 0

# Only worktrees get a label. Telling panes apart matters when they sit side by
# side; a lone "main" pane just adds noise to the border and the sidebar. A
# linked worktree has .git as a file, not a directory.
is_worktree() {
  [ -f "$(git -C "$1" rev-parse --show-toplevel 2>/dev/null)/.git" ]
}

# Pane border label. herdr has no per-pane colour, so a coloured emoji picked by
# a hash of the branch name is the only way to make the columns colour-codeable.
# The same branch therefore always gets the same colour.
pane_label_of() {
  local branch="$1" markers=(🔴 🟠 🟡 🟢 🔵 🟣)
  printf '%s %s' "${markers[$(($(printf '%s' "$branch" | cksum | cut -d' ' -f1) % ${#markers[@]}))]}" "$branch"
}

# Even out a row of columns. Moving one boundary redistributes everything to its
# right proportionally, so settle the boundaries left to right.
equalize_columns() {
  local probe="$1" layout total n target id width delta dir amount
  layout="$(herdr pane layout --pane "$probe" 2>/dev/null)" || return 0
  # Skip layouts that mix horizontal splits: a single row means every pane
  # shares the same top edge.
  jq -e '[.result.layout.panes[].rect.y] | unique | length == 1' <<<"$layout" >/dev/null 2>&1 || return 0
  n="$(jq -r '[.result.layout.panes[]] | length' <<<"$layout")"
  [ "${n:-0}" -ge 2 ] || return 0
  total="$(jq -r '.result.layout.area.width // empty' <<<"$layout")"
  [ -n "$total" ] || return 0
  target=$((total / n))

  # The rightmost column takes whatever is left, so it needs no adjustment.
  for id in $(jq -r '[.result.layout.panes[]] | sort_by(.rect.x) | .[:-1][].pane_id' <<<"$layout"); do
    width="$(herdr pane layout --pane "$id" 2>/dev/null \
      | jq -r --arg id "$id" '.result.layout.panes[] | select(.pane_id == $id) | .rect.width')"
    [ -n "$width" ] || continue
    delta=$((target - width))
    [ "$delta" -eq 0 ] && continue
    if [ "$delta" -gt 0 ]; then dir=right; else dir=left; delta=$((-delta)); fi
    amount="$(awk -v d="$delta" -v t="$total" 'BEGIN { printf "%.4f", d / t }')"
    herdr pane resize --pane "$id" --direction "$dir" --amount "$amount" >/dev/null 2>&1
  done
}

workspaces="$(herdr workspace list 2>/dev/null)" || exit 0

# Labels can carry an auto-assigned "[3] " prefix, so compare without it.
target="$(jq -r --arg repo "$repo" --arg self "$HERDR_WORKSPACE_ID" '
  .result.workspaces[]
  | select(.workspace_id != $self)
  | select((.label | sub("^\\[[0-9]+\\] "; "")) == $repo)
  | "\(.workspace_id)\t\(.active_tab_id)"
' <<<"$workspaces" 2>/dev/null | head -1)"

if [ -z "$target" ]; then
  # Nowhere to move to, so this workspace becomes the canonical one. Its label
  # is corrected to match the panes it actually holds. A later `cd` can break
  # that again, so this is startup-time self-healing, not an invariant.
  label="$(jq -r --arg self "$HERDR_WORKSPACE_ID" '
    .result.workspaces[] | select(.workspace_id == $self) | .label | sub("^\\[[0-9]+\\] "; "")
  ' <<<"$workspaces" 2>/dev/null)"

  # Panes outside a repository do not vote. If several repositories are mixed in
  # there is no right answer, so leave the label alone.
  repos=""
  while IFS= read -r dir; do
    [ -n "$dir" ] || continue
    name="$(repo_name_of "$dir")" || continue
    case " $repos " in *" $name "*) ;; *) repos="$repos $name" ;; esac
  done < <(herdr pane list --workspace "$HERDR_WORKSPACE_ID" 2>/dev/null \
    | jq -r '.result.panes[] | (.foreground_cwd // .cwd) // empty' 2>/dev/null)
  repos="${repos# }"

  if [ -n "$repos" ] && [ "$repos" = "${repos%% *}" ] && [ "$label" != "$repos" ]; then
    herdr workspace rename "$HERDR_WORKSPACE_ID" "$repos" >/dev/null 2>&1
  fi

  # Label the first pane too, so it is already distinguishable once others join.
  branch="$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null)"
  [ -n "$branch" ] && is_worktree "$cwd" \
    && herdr pane rename "$HERDR_PANE_ID" "$(pane_label_of "$branch")" >/dev/null 2>&1
  exit 0
fi

target_ws="${target%%$'\t'*}"
target_tab="${target#*$'\t'}"

# Add a column: no new tab, no horizontal split.
probe="$(herdr pane list --workspace "$target_ws" 2>/dev/null \
  | jq -r --arg tab "$target_tab" '[.result.panes[] | select(.tab_id == $tab)][0].pane_id // empty')"
[ -n "$probe" ] || exit 0
layout="$(herdr pane layout --pane "$probe" 2>/dev/null)" || exit 0

# Refuse to move when the column count or width limit would break. Silently
# staying behind in another workspace is confusing, so say why.
count="$(jq -r '[.result.layout.panes[]] | length' <<<"$layout" 2>/dev/null)"
[ -n "$count" ] || exit 0
if [ "$count" -ge "$MAX_COLUMNS" ]; then
  herdr notification show "$repo はこれ以上並べられません" \
    --body "${MAX_COLUMNS}列が埋まっているのでこのペインは寄せていません。1つ閉じてから起動し直すと並びます" \
    >/dev/null 2>&1
  exit 0
fi
tab_width="$(jq -r '.result.layout.area.width // empty' <<<"$layout" 2>/dev/null)"
[ -n "$tab_width" ] || exit 0
if [ "$((tab_width / (count + 1)))" -lt "$MIN_COLS" ]; then
  herdr notification show "$repo はこれ以上並べられません" \
    --body "1列が${MIN_COLS}桁を下回るのでこのペインは寄せていません。画面を広げるか、既存のペインを閉じてください" \
    >/dev/null 2>&1
  exit 0
fi

# Split the widest column so narrow ones do not keep getting narrower.
victim_pane="$(jq -r '[.result.layout.panes[]] | max_by(.rect.width) | .pane_id // empty' <<<"$layout" 2>/dev/null)"
[ -n "$victim_pane" ] || exit 0

# The user is looking at this pane right after startup, so take the focus along.
moved="$(herdr pane move "$HERDR_PANE_ID" --tab "$target_tab" --split right --target-pane "$victim_pane" --focus 2>/dev/null)"
[ -n "$moved" ] || exit 0

# The move assigns a new pane ID; everything below uses that one.
pane="$(jq -r '.result.move_result.pane.pane_id // empty' <<<"$moved" 2>/dev/null)"
[ -n "$pane" ] || exit 0

# Nested splits leave each new column narrower than the last, so even them out.
equalize_columns "$pane"

branch="$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null)" || exit 0

# Put the branch on the pane border so stacked worktrees are recognisable.
is_worktree "$cwd" && herdr pane rename "$pane" "$(pane_label_of "$branch")" >/dev/null 2>&1

# Name the agent after the branch too, so `herdr agent prompt <name>` works and
# the sidebar lines up with the columns. Branches share a prefix (dev-, an issue
# key) and differ at the end, so keep the tail when one is too long.
name="$(printf '%s' "$branch" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9_-]\{1,\}/-/g')"
if [ "${#name}" -gt 32 ]; then
  # Cutting mid-word is unreadable: pick up from the last separator that fits.
  tail_name="$(awk -F- '{ acc=""; for (i=NF; i>=1; i--) { cand=(acc=="" ? $i : $i "-" acc); if (length(cand) > 32) break; acc=cand } print acc }' <<<"$name")"
  # Fall back to a hard cut when there is no separator to pick up from.
  name="${tail_name:-$(cut -c1-32 <<<"$name")}"
fi
name="$(printf '%s' "$name" | sed -e 's/^[^a-z]*//' -e 's/[^a-z0-9]\{1,\}$//')"
[ -n "$name" ] || exit 0

taken="$(herdr agent list 2>/dev/null | jq -r '.result.agents[].name // empty' 2>/dev/null)"
candidate="$name"
for i in 2 3 4 5; do
  grep -qxF "$candidate" <<<"$taken" || break
  candidate="$(cut -c1-30 <<<"$name")-$i"
done
grep -qxF "$candidate" <<<"$taken" && exit 0

# Agent detection can lag the session start a little, so retry a few times.
for _ in 1 2 3 4 5; do
  herdr agent rename "$pane" "$candidate" >/dev/null 2>&1 && break
  sleep 0.4
done

exit 0
