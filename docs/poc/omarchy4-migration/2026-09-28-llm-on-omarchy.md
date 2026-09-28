# Apply llm/ (Claude Code skills/hooks/settings) to omarchy too, with two required fixes

Considered leaving Claude Code integration to whatever omarchy provides on
its own (it does have some: a symlinked `omarchy` skill, agent-usage
tracking, theme sync into Claude's settings). Rejected — this repo's
`llm/skills/*`, hooks, and `AGENTS.md` are the actual point of running Claude
Code here, not a nice-to-have.

Found two collisions with omarchy's own provisioning, both in the same class
as the herdr config-seed issue:

1. `scripts/llm.sh` symlinks the whole `~/.claude/skills` directory to
   `llm/skills`. omarchy's `omarchy-provision-user` runs first, creates
   `~/.claude/skills` as a real directory, and symlinks individual skills
   (`omarchy`, `diagnose-crash`) into it. Since the directory already exists
   by the time `make llm` runs, `llm.sh`'s `[ ! -e ... ]` check silently skips
   — none of this repo's skills would ever be linked in. Fix: symlink each
   skill under `llm/skills/*` individually into `~/.claude/skills/<name>`,
   matching omarchy's own per-skill convention, instead of one directory-level
   symlink. (Worth doing on both OSes for one consistent code path, not just
   omarchy.)

2. `scripts/llm.sh` copies `llm/settings.json` to `~/.claude/settings.json`
   only if absent. `bin/omarchy-theme-set-claude` creates/edits that same file
   (`jq '.theme = "custom:omarchy"'`) as part of applying the omarchy theme,
   which happens well before anyone runs `make llm`. So on omarchy the file
   already exists by the time `llm.sh` runs, and this repo's settings
   (hooks, permissions) never land. Fix: merge with `jq` on every run, the
   same way `llm.sh` already merges the herdr-repo-workspace and
   shut-up-and-code hook registrations into this file — not copy-if-absent.

The Homebrew-cask migration check at the top of `llm.sh` (checking for
Claude Code installed via `brew`) is a no-op on Linux; no change needed
there, just confirm it doesn't error when `brew` isn't on PATH.
