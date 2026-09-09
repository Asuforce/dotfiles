---
name: grill-with-docs
description: Grilling session that challenges your plan against the existing domain model, sharpens terminology, and updates documentation (CONTEXT.md, ADRs, PoC decision log) inline as decisions crystallise. Use when user wants to stress-test a plan against their project's language and documented decisions.
---

<what-to-do>

Interview me relentlessly about every aspect of this plan until we reach a shared understanding. Treat the plan as a decision tree — each decision branches into the next ones that hang off it.

Work in **rounds**. The **frontier** is every decision whose prerequisites are already settled — i.e. everything you can ask right now without guessing. Batch the whole frontier into one round: number each question and attach your recommendation with a one-to-two line trade-off. Wait for my answers, then recompute the frontier (my answers may reshape the tree) and issue the next round. If one question in a round depends on another unresolved question in the *same* round, push it to a later round instead of guessing.

If a question can be answered by exploring the codebase, explore it yourself rather than asking me — don't make me fetch facts you can look up. For exploration wide enough to blow up context (cross-repo, many files), delegate to a research subagent instead of doing it inline yourself.

The frontier is empty (converged) when every branch has been visited and no assumption is still implicit. Don't move to implementation until I've confirmed convergence.

</what-to-do>

<supporting-info>

## Domain awareness

During codebase exploration, also look for existing documentation:

### File structure

Most repos have a single context:

```
/
├── CONTEXT.md
└── src/
```

If a `CONTEXT-MAP.md` exists at the root, the repo has multiple contexts. The map points to where each one lives:

```
/
├── CONTEXT-MAP.md
├── src/
│   ├── ordering/
│   │   └── CONTEXT.md
│   └── billing/
│       └── CONTEXT.md
```

Create `CONTEXT.md` lazily — only when the first term is resolved.

### Where decisions get recorded

Don't assume this project keeps a file-based decision record (ADRs, a PoC log) at all — plenty of projects don't, and that's a legitimate state, not a gap for you to fill unasked. Work this out *before* the first time you'd offer to record something:

1. **Look for an existing convention first.** A `docs/adr/`, `docs/decisions/`, `docs/rfc/`, or similarly-named directory, under whatever naming this project already uses; a pointer to an external system (Notion, Confluence, a wiki, a design-docs tool) mentioned in the README or a CLAUDE.md/AGENTS.md. If you find one, follow *its* location and format — treat [ADR-FORMAT.md](./ADR-FORMAT.md) / [POC-FORMAT.md](./POC-FORMAT.md) as a fallback shape to offer, not a standard to impose over an existing one.
2. **If you find nothing, ask — once, the first time it actually matters** (i.e. the first time a decision is ready to record). Does this project want a written decision record at all, and if so where: a new `docs/adr/` here, an existing external tool, or nowhere (the PR/commit description is the record)? Don't create `docs/adr/` or `docs/poc/` speculatively ahead of that answer.
3. **Remember the answer for the rest of the session** so you're not re-asking every time a decision comes up. If the project has no such convention and the user doesn't want to start one, keep grilling and stop offering to record anything — the interview itself is still the value.

## During the session

### Challenge against the glossary

When the user uses a term that conflicts with the existing language in `CONTEXT.md`, call it out immediately. "Your glossary defines 'cancellation' as X, but you seem to mean Y — which is it?"

### Sharpen fuzzy language

When the user uses vague or overloaded terms, propose a precise canonical term. "You're saying 'account' — do you mean the Customer or the User? Those are different things."

### Discuss concrete scenarios

When domain relationships are being discussed, stress-test them with specific scenarios. Invent scenarios that probe edge cases and force the user to be precise about the boundaries between concepts.

### Cross-reference with code

When the user states how something works, check whether the code agrees. If you find a contradiction, surface it: "Your code cancels entire Orders, but you just said partial cancellation is possible — which is right?"

### Update CONTEXT.md inline

When a term is resolved, update `CONTEXT.md` right there. Don't batch these up — capture them as they happen. Use the format in [CONTEXT-FORMAT.md](./CONTEXT-FORMAT.md).

`CONTEXT.md` should be totally devoid of implementation details. Do not treat `CONTEXT.md` as a spec, a scratch pad, or a repository for implementation decisions. It is a glossary and nothing else.

### Offer PoC log entries for decisions that aren't settled yet

Not every decision clears the bar for an ADR the moment it's made — plenty are "let's go with this for now, we might reverse it." Those still deserve a written trace, just not a permanent one. When you land on one of those, and the project has a decision-record destination (see above), offer to log it there using the format in [POC-FORMAT.md](./POC-FORMAT.md) if no format of its own applies. It's cheap to write and safe to get wrong — that's the point.

### Offer ADRs sparingly

Only offer to create an ADR when all of these are true:

1. **Hard to reverse** — the cost of changing your mind later is meaningful
2. **Surprising without context** — a future reader will wonder "why did they do it this way?"
3. **The result of a real trade-off** — there were genuine alternatives and you picked one for specific reasons
4. **Survived contact with a PoC log entry, if one exists** — if this decision already went through the PoC log and got reversed there, it's not ADR-ready yet; if it went through and held, that's a point in favor of writing the ADR now

If any of 1-3 is missing, skip the ADR. If the project has a decision-record destination, use the format in [ADR-FORMAT.md](./ADR-FORMAT.md) unless its own convention says otherwise.

</supporting-info>
