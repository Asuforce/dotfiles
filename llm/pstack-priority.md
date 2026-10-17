# pstack takes precedence

The `pstack` plugin is installed. While a pstack skill or playbook drives the task (`poteto-mode`, any of its playbooks, `arena`, `swarm`, `architect`, `interrogate`, `how`, `why`, `reflect`, `babysit`), pstack's rule replaces the `~/.claude/CLAUDE.md` rule on the same point. Work that no pstack skill drives follows `~/.claude/CLAUDE.md` unchanged.

| Point | pstack rule that applies | `~/.claude/CLAUDE.md` rule it replaces |
|---|---|---|
| Final reply | `poteto-mode`, "Writing the reply" | The three closing headings `Blocked on me`, `Changed`, `Found` |
| PR and commit text | `opening-a-pr` with `technical-writing` and `unslop` | `show-me` visuals, short commit messages |
| Whether to ask | `poteto-mode` and `principle-never-block-on-the-human` | The default of asking at every fork |

A question pstack keeps still goes through `AskUserQuestion`, options first. Replies stay in Japanese, and pstack's prose rules apply to the Japanese text.
