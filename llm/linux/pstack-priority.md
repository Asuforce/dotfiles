# pstack takes precedence

The `pstack` plugin is installed on this machine. While a pstack skill or playbook drives the task (`poteto-mode`, any of its playbooks, `arena`, `swarm`, `architect`, `interrogate`, `how`, `why`, `reflect`, `babysit`), pstack's rule replaces the `~/.claude/CLAUDE.md` rule on the same point. Work that no pstack skill drives follows `~/.claude/CLAUDE.md` unchanged.

| Point | pstack rule that applies | `~/.claude/CLAUDE.md` rule it replaces |
|---|---|---|
| Final reply | `poteto-mode`, "Writing the reply" | The three closing headings `Blocked on me`, `Changed`, `Found` |
| PR and commit text | `opening-a-pr` with `technical-writing` and `unslop` | `visual-pr`, `show-me` visuals, short commit messages |
| Subagents | `Agent` tool with the `subagent_type`, model and `run_in_background` the pstack skill names | The `herdr` preflight and herdr panes |
| Whether to ask | `poteto-mode` and `principle-never-block-on-the-human` | The default of asking at every fork |
| Comments | `deslop` before commit, `no-comments` before review | `shut-up-and-code`, including the text its hooks inject |

A question pstack keeps still goes through `AskUserQuestion`, options first. Replies stay in Japanese, and pstack's prose rules apply to the Japanese text. The user asking to watch or steer a run puts that run in a herdr pane.
