## Style
- Speak in Japanese.
- Keep emphasis sparing in documents.

## Pull requests
- When an implementation task changes code in a Git repository, verify the changes, commit the task's changes on a feature branch, push, and open a PR unless the user asks to stop earlier. If the branch already has an open PR for the task, update it and report its link.
- In T3 Code, link the PR to the thread when the tool is available. Follow any repository-specific rules for review and merging.

## Documents
PR descriptions follow `pr`, and design or technical documents (ADR, PoC decision log, `CONTEXT.md`, README, design notes) go through `show-me`, both unprompted, with at least one visual carrying the main point.
When the repo's PR template, a prompt, or a skill sets the PR shape, follow it instead of `pr`.
When the repo sets a document's shape, follow that shape; still run it through `show-me`.
Visuals are text only (Mermaid, file or call trees, pseudocode, `diff`), since HTML cannot live in a PR body or Markdown file. Commit messages, review comments, and short replies are exempt.

## Replies
- End the final message with `Blocked on me`, `Changed`, `Found`, unless a skill sets the reply format.
- A settled answer stays settled unless asked or shown a problem.
- Run commands yourself. Hand over only interactive ones (login, password) or ones the classifier denied, and report a denial once.

## UI
- Avoid secondary labels or descriptions that restate the primary label. Use grouping, spacing, and hierarchy to convey structure instead of explanatory text.
- Keep text that carries information the layout cannot: form labels, units, constraints, consequences of destructive actions, and empty/error guidance. Icon-only controls still need accessible names.

# graphify
- **graphify** (`~/.claude/skills/graphify/SKILL.md`) - any input to knowledge graph. Trigger: `/graphify`
When the user types `/graphify`, use the installed graphify skill or instructions before doing anything else.
When a question is about a codebase's architecture or file relationships and `graphify-out/` exists in the working directory, read `graphify-out/GRAPH_REPORT.md` before searching files.

## Model Delegation (Antigravity)
- When running on Antigravity as Gemini 4 Hydrogen, proactively delegate self-contained subtasks (codebase research, file exploration, review, test runs, and routine edits) to `claude-sonnet-5-5` via `delegate_task` (`providerInstanceId: "antigravity"`, `model: "claude-sonnet-5-5"`, `options: { thought_level: "low" }` for routine tasks or `"medium"` for complex ones) to reduce token cost.
