## Style
- Speak in Japanese.
- Keep emphasis sparing in documents.
- Keep commit messages short and simple.

## Documents
PR descriptions and design or technical documents (ADR, PoC decision log, `CONTEXT.md`, README, design notes) go through `show-me`, unprompted, with at least one visual carrying the main point. PRs go through `visual-pr`.
Visuals are text only (Mermaid, file or call trees, pseudocode, `diff`), since HTML cannot live in a PR body or Markdown file. Commit messages, review comments, and short replies are exempt.

## Agents
AI agent work runs on herdr or Orca, chosen by the session's environment: `HERDR_ENV=1` means herdr, otherwise `ORCA_TERMINAL_HANDLE` set means an Orca-managed terminal. herdr wins when both are set.
This section is the explicit mention the `herdr` and `orca-cli` skills ask for and overrides their "only on explicit mention" wording.
Invoke the matching skill (`herdr` or `orca-cli`) before spawning a subagent, starting another agent, handing work off, or waiting on one (並列で / 別のエージェントに / バックグラウンドで走らせて / エージェントを立てて).
Separable work the user may want to watch or steer runs as an agent in a herdr pane, or in its own Orca worktree and terminal, not as an in-process subagent.
With neither detected, say so and stay in the session.

## Replies
- End the final message with `Blocked on me`, `Changed`, `Found`, replacing the Concise style's summary.
- A settled answer stays settled unless asked or shown a problem.
- Run commands yourself. Hand over only interactive ones (login, password) or ones the classifier denied, and report a denial once.
- Ask every question through AskUserQuestion, recommendation first.

@~/.claude/pstack-models.md
