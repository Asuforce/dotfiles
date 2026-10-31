# llm/

Claude Code and Codex configuration for this repository, installed by `scripts/llm.sh`. See the root `CLAUDE.md` for the pointers into this directory; this file carries the reasoning behind them.

## Skills only, no commands

Reusable agent instructions live in `llm/skills/<name>/SKILL.md` only — there is no `llm/commands/` and no `~/.claude/commands` link. Slash commands and skills overlap in what they can express, but a skill carries a `description` that lets the model reach for it unprompted, so keeping both meant maintaining two mechanisms for one job.

`apply-review`, `create-pr`, and `create-repo` moved over from commands and have since been dropped. `create-pr` gave way to pstack's `opening-a-pr`; `apply-review` and `create-repo` went unused in four weeks of session logs, since `code-review` and a plain request to `gh repo create` cover the same ground. Everything else was dropped once Claude Code shipped a built-in that already covered it — the standing test for whether a skill still belongs here:

- `review-pr` — `mattpocock-skills`' `code-review` reviews a branch or PR (the bundled `code-review` it first gave way to is now hidden).
- `guide` — plan mode explores read-only and presents options for approval, with the `Plan` and `feature-dev:code-architect` agents for the same job in a subagent.
- `empirical-prompt-tuning` — `claude plugin eval` runs eval cases with LLM graders, repeated runs, and a no-plugin ablation arm, and resolves a `~/.claude/skills/<name>` directory as a target.
- `find-skills` — `/plugin` and `claude plugin install` discover and install skills without the separate `npx skills` ecosystem it assumed.
- `autopilot`, then `asuforce-mode` — a hand-rolled copy of pstack's autonomous run (grill, then work through to merge on personal repos only), replaced by the pstack plugin's `poteto-mode` itself.

Current roster, each with no built-in or plugin equivalent:

- `before-compact` saves durable memory before `/compact`.
- `claude-restart` restarts herdr panes still running an outdated Claude Code and resumes each session.
- `design-renewal` and `design-score-loop` redesign a site from references and refine it until it passes an Awwwards-style score.
- `show-me`, `yomiyasu`, `i-have-adhd`, `chief-of-staff` and `emil-design-eng` are vendored; see [Vendored skills](#vendored-skills).
