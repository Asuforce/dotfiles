# Codex does the coding under pstack

The `codex` plugin is installed. While a pstack skill or playbook drives the task, code-writing delegates go to Codex through the `codex:codex-rescue` agent instead of `poteto-agent`. The main chat keeps planning, verification, judgment, prose and PR text.

## Roles

| pstack role | Runs on |
|---|---|
| feature, refactoring, bug-fix, perf-issue | `codex:codex-rescue` |
| arena runners | one Codex runner next to the Claude ones |
| interrogate reviewers | `/codex:review` added to the sonnet and opus reviewers |
| swarm workers | haiku, unchanged |
| judgment and prose, synthesizers, how, why, reflect | Claude, unchanged |

Do not delegate a change the main chat can finish in a few edits. Do not send two Codex runs at files that overlap; give each its own worktree or split by file.

## Model and effort

Pass these to `codex:codex-rescue` explicitly, since it leaves both unset otherwise and `~/.codex/config.toml` would decide.

| Task | `--model` | `--effort` |
|---|---|---|
| Default implementation, bug-fix, refactoring | `gpt-6.1-sol` | `low` |
| Mechanical edits: renames, boilerplate, test scaffolding, config | `gpt-6-luna` | `medium` |
| Perf work, or a root cause that a `low` run missed | `gpt-6.1-sol` | `high` |

Raise effort only after a run fails verification; do not start high. `gpt-6-astra` and `xhigh` or above are for a case the user names.

## Brief

Codex does not read pstack's skills. Each delegation states the goal, the files in scope, the completion check (a command that must pass), and the constraints that matter from the principles: fix the root cause, no new comments, no unrelated cleanup. `~/.codex/AGENTS.md` already carries the language and style rules.

## Verify

A Codex result is a claim. Read the diff, run the completion check yourself, and send a failure back with `--resume` and the failing output rather than fixing it in the main chat.
