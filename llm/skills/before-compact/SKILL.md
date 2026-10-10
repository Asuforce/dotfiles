---
name: before-compact
description: Use before /compact to save durable memory from the session.
disable-model-invocation: true
---

# Before compact

Compaction drops detail. Save what a later session needs, then hand back to the user.

1. List the facts from this session that are not in the code or git history: user preferences, corrections, project state and deadlines, pointers to outside resources.
2. Read MEMORY.md and the memory files it indexes. Update a file that already covers a fact instead of adding a duplicate, and delete one the session proved wrong.
3. Write each new fact as its own file, then add one index line per file.
4. Report the files touched in one line each, then say "/compact を実行してください".

A skill cannot run `/compact` itself.
