# PoC Decision Log Format

This is the fallback shape to use once SKILL.md's "Where decisions get recorded" step has confirmed the project (a) wants a written decision record and (b) has no existing convention of its own to follow instead. Don't apply this format — or create `docs/poc/` — before that's settled.

A place to record "let's go with this for now" — decisions too fresh to be an ADR, kept on the assumption they might get reversed.

The only difference from an [ADR](./ADR-FORMAT.md) is confidence. This is allowed to be wrong. If it gets reversed, don't delete the entry — append to it.

Create `docs/poc/` only once the first entry is actually ready to write.

## One decision, one file

Place it at `docs/poc/<chunk-of-work>/YYYY-MM-DD-<slug>.md`.

```md
# Sync the repo credential via secret-sync instead of a hand-created Secret

Hand-created Kubernetes Secrets get silently lost on cluster recreation, with no
recovery procedure (ADR 0002). An External Secrets Operator was the other option,
rejected because it adds another component to operate. Revisit if we need a store
other than Secret Manager.

- Ticket: https://example.atlassian.net/browse/PROJ-948
- PR: https://github.com/org/repo/pull/12
```

- **What you picked, what you rejected, and why** is enough. Link to the PR for detail. The only thing you won't be able to reconstruct later is the rejected option and its reason — don't drop that part.
- **Attach "what would change our mind" to every rejected option.** PoC assumptions shift; that's the hook for revisiting later.
- **Append when it gets reversed** (`→ 2026-09-15: reversed. because X`). The story of the reversal is the most useful part at cleanup time.
- **No index file.** `ls` is enough of a listing. An index becomes a merge-conflict magnet across every PR that touches this directory.
- **No frontmatter, no template.** The moment you owe a template, entries get too heavy to write.
- **No review required.** Fine to ship in the same PR as the work it documents.

## Directories

Cut one per chunk of work. Name it after the epic/initiative if it maps to one; name it after the topic if the work cuts across several. Ticket links inside each entry carry the traceability — the directory name doesn't need to.

Create a directory only when you need it. Don't scaffold empty ones ahead of time. When unsure where something goes, drop it straight under `docs/poc/` and move it later.

## Cleanup pass

When a chunk of work settles, read through its directory:

1. **Promote to [ADR](./ADR-FORMAT.md)** anything that held. If several entries cite the same reason for a choice, that shared reason is the ADR (not any single entry). A one-off, hard-to-reverse call becomes its own ADR directly.
2. **Absorb into `CONTEXT.md`** whatever isn't ADR-worthy but is still load-bearing context — a term, a constraint, the story of a reversal — in one line.
3. **Delete the directory.** Nothing is lost; it's still in git history.

Cleanup means all three steps, not just reading. The invariant to hold: if it's still sitting in `docs/poc/`, it hasn't been extracted yet.
