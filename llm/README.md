# llm/

Claude Code configuration for this repository, installed by `scripts/llm.sh`. See the root `CLAUDE.md` for the pointers into this directory; this file carries the reasoning behind them.

## Skills only, no commands

Reusable agent instructions live in `llm/skills/<name>/SKILL.md` only — there is no `llm/commands/` and no `~/.claude/commands` link. Slash commands and skills overlap in what they can express, but a skill carries a `description` that lets the model reach for it unprompted, so keeping both meant maintaining two mechanisms for one job.

`apply-review`, `create-pr`, and `create-repo` moved over from commands and have since been dropped. `create-pr` gave way to pstack's `opening-a-pr`; `apply-review` and `create-repo` went unused in four weeks of session logs, since `code-review` and a plain request to `gh repo create` cover the same ground. Everything else was dropped once Claude Code shipped a built-in that already covered it — the standing test for whether a skill still belongs here:

- `review-pr` — the built-in `code-review` skill takes a PR number and can post or apply its findings.
- `guide` — plan mode explores read-only and presents options for approval, with the `Plan` and `feature-dev:code-architect` agents for the same job in a subagent.
- `empirical-prompt-tuning` — `claude plugin eval` runs eval cases with LLM graders, repeated runs, and a no-plugin ablation arm, and resolves a `~/.claude/skills/<name>` directory as a target.
- `find-skills` — `/plugin` and `claude plugin install` discover and install skills without the separate `npx skills` ecosystem it assumed.

Add new instructions as `llm/skills/<name>/SKILL.md`, and use `disable-model-invocation: true` for the side-effecting ones instead of reintroducing a command.

`scripts/llm.sh` links each skill into `~/.claude/skills/` individually rather than linking the directory, so a skill added under `llm/skills/` appears only after `make llm`, and one removed or renamed leaves a dangling link to delete by hand.

## Vendored skills

`llm/upstream-skills.tsv` records the upstream commit each vendored skill has been reviewed through. `scripts/llm.sh` prints a compare URL when upstream has moved past that commit; it applies nothing, because these are prompts that have to be read before they're taken. It fails open on a missing `gh`, an unreachable network, or a missing manifest.


### `yomiyasu` (from `nanaism/yomiyasu`)

Rewrites AI-generated Japanese prose into natural Japanese: it restores the subject-verb-object structure AI output tends to drop, replaces figurative verbs (`壊れる`, `効く`, `溶かす`) with literal ones, and strips emoji, trailing colons, and excess bold/bullets. No built-in covers this — `code-review` and `writing-for-agents` govern structure and correctness, not Japanese prose register.

Upstream ships the skill twice: once at the repo root (for `npx skills add`) and once under `skills/yomiyasu/` (for its Claude Code plugin marketplace). The two are identical; the local copy is vendored from `skills/yomiyasu/` since that is the self-contained directory. Dropped: `.claude-plugin/` (plugin manifests, meaningless outside the marketplace flow) and `assets/algo-artis.png` (a logo image the skill itself never reads).

Upstream's `SKILL.md` warns against running it alongside other Japanese style/proofreading skills, since the instructions can conflict; disable one of them if that happens.


### `i-have-adhd` (from `ayghri/i-have-adhd`)

Shapes responses for a reader with ADHD: next action first, numbered steps, one concrete closing step, no preamble or closers. Invoked with `/i-have-adhd` and stays on until "stop adhd mode". No built-in covers this; the Concise output style only shortens, it does not reorder around the next action.

It ships `disable-model-invocation: true` upstream and keeps it here, so it is opt-in per session. It overlaps the Concise output style and conflicts with the global rule that every turn ends with `Blocked on me` / `Changed` / `Found`; the skill's own "a rule fights the harness" clause lets the harness win.

Upstream's `agents/` (`openai.yaml`, `gemini.toml`) was dropped as other-vendor exports.

## Plugins

`llm/plugins.tsv` lists the plugins `scripts/llm.sh` installs, one `<marketplace source>\t<plugin id>[\t<OS>]` per line, so a new machine gets the same set from `make llm`. The script adds each marketplace and installs each plugin at scope `user`, skipping what is already there (`claude plugin marketplace list --json` / `claude plugin list --json`). A source of `-` marks a plugin Claude Code ships itself, which is enabled through `enabledPlugins` instead and checked there, since `claude plugin list` does not show it. A third column holding a `uname -s` name (`Linux`) limits the row to that OS; other systems print a skip line.

```
llm/plugins.tsv
├─ tigerless-labs/autoharness   autoharness@autoharness
├─ hamzafer/claude-code-mods    token-weather, mission-control, usage-meter
├─ davekiss/env                 env@davekiss
├─ aieo-product/claude_qamods   qa-guide@claude-qamods
├─ -                            cc-plugin-you-should-know@builtin
└─ cursor/plugins               pstack@cursor-plugins

llm/pstack-priority.md ──link──▶ ~/.claude/rules/pstack-priority.md
```

They are plugin-installed rather than vendored like the skills above, because each ships hooks, an MCP server or a backend that a skill-only copy under `llm/skills/` would not run. None carries local changes, so none has an entry in `llm/upstream-skills.tsv`. A version bump needs `claude plugin marketplace update <name> && claude plugin update <id>`, then a restart. `cloudflare@cloudflare` is installed by hand on this machine and is not in the list.

- `autoharness` self-learns skills from session work into `.claude/skills/` and prunes them by usage rate. It ships a Python backend, an MCP server (`stage_skill`) and `SessionStart`/`Stop`/`PreToolUse`/`SessionEnd` hooks.
- `token-weather` draws the context fill and a prompt-cache countdown above the prompt. Session transcripts here reach 500k to 880k tokens and often sit idle for over five minutes, which is where both readouts pay off.
- `usage-meter` shows the 5-hour and 7-day plan usage.
- `mission-control` opens `/mission`, a live tree of agents and tool calls. Its code-map view needs macOS and Chrome, so only the agent view applies on Linux. It makes one small model call per change to summarise it.
- `env` has Claude ask for a value in a pane it cannot read, so tokens for Cloudflare and Terraform never enter the transcript.
- `qa-guide` opens a side pane when Claude asks via `AskUserQuestion`, explaining why it asks and what each option leads to. Explanations come from one Haiku call per question over a prompt capped at 12,000 characters. The pane opens on its own only at 144 columns or wider; `/qa-guide` opens it at any width. It needs the early-access function-hooks API of Claude Code 2.1.286 or later.
- `cc-plugin-you-should-know` runs a side agent that flags what the user or Claude may have missed.
- `pstack` is Cursor's own plugin, from `cursor/plugins`: `poteto-mode` routes work to playbooks and skills. The package ships no hooks, so nothing starts it by itself; it runs when invoked or when the autoharness skill `pstack-poteto-mode-routing` matches the task. pstack's skills defer to `CLAUDE.md` on conflicts. This setup wants the reverse, so `llm/pstack-priority.md` is linked into `~/.claude/rules/` and names the three points where pstack's rule replaces `CLAUDE.md`'s: the closing headings, PR and commit text, and whether to ask. It is not under `llm/skills/`, so it is not linked as a skill. Model choices per role live in the untracked `~/.claude/pstack-models.md`, which `llm/AGENTS.md` imports.

## herdr integration

`scripts/llm.sh` regenerates `llm/skills/herdr/SKILL.md` from `herdr --skill` on every run (git-ignored, so herdr upgrades do not show up as diffs) and installs herdr's Claude Code integration hook plus the repository-owned `herdr-repo-workspace.sh` hook, which keeps herdr at "one repository = one workspace = side-by-side worktrees" (adapted from https://zenn.dev/gemcook/articles/herdr-worktree-parallel).

`herdr-tab-title.sh` runs on `Stop` and copies the `ai-title` Claude Code writes into the transcript onto the herdr tab label (24 characters at most). It only replaces a label herdr numbered itself (`1`, `2`, ...) or the title it set earlier from the same pane, so a tab renamed by hand, or claimed by another pane's session, keeps its name. On `/clear` (`SessionStart`) it puts the herdr-assigned number back on a tab still carrying the title it set, and the next session's first `Stop` names it afresh.

## Status line

`llm/statusline.sh` is the Claude Code status line (model, repository, branch). The context bar, rate limits and cost it used to carry moved to the `token-weather` and `usage-meter` mods, which draw them above the prompt. `scripts/llm.sh` symlinks it to `~/.claude/statusline.sh` and adds the `statusLine` entry to `settings.json` only when none exists, so a machine that configured its own keeps it.

`llm/permissions-allow.json` lists the Bash rules (`make link` and the other `make` targets) that `scripts/llm.sh` unions into `permissions.allow` in `settings.json`. The merge runs on Linux only. Existing entries on a machine are kept.
