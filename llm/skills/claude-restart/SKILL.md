---
name: claude-restart
description: Restart the herdr panes still running an outdated Claude Code after an update, resuming each session. Use when the user asks to restart or update their Claude panes.
disable-model-invocation: true
---

Run `bash ~/.claude/skills/claude-restart/restart.sh` and report its output. Pass `-n` first to list the panes without restarting them.

The script compares each herdr pane's running claude version with the installed one, then stops every idle stale pane with SIGTERM and resumes it with `claude --resume <session>`. The session id comes from the claude process's own `~/.claude/sessions/<pid>.json`, not from herdr, whose tracked id a subagent session (the autoharness reflector) can overwrite; the id used is printed per pane. Panes that are working or blocked are skipped, including the pane this skill runs in; run it again from another pane once they settle.
