---
name: design-renewal
description: Use when redesigning a site from reference sites or screenshots, or when scoring a design.
---

# Design renewal

Four prompt shapes took the official renewal from reference to approval in one or two rounds. When the request lacks a shape, supply it before touching code.

## Reference round

Code stays untouched until the user picks.

1. Open each reference site in Chrome and read computed styles: font sizes, weights, colors, spacing, radius. A screenshot alone gives no px or hex. If the environment cannot open the sites, say so first.
2. Per site, what it does well in layout, typography, color, spacing, white space. Then the shared traits.
3. Ask which traits to adopt through AskUserQuestion, and wait.
4. Write DESIGN.md, one screen. Mark each value as measured, estimated, or chosen. Never invent a value.
5. Import it from the root CLAUDE.md with an `@` line, outside backticks. Add the per-page finishing rule.

## Adjustment round

- A request made only of adjectives ("more texture", "too dark", "feels off") gets one question first: a reference URL or a scene. Ask once, before the second fix attempt.
- A scene ("peeking in from the right half", "firmly landed on the moon") or a reference image resolves in one round. Restate it as a concrete visual target, then build.
- A one-line constraint ("no license violations", "dark only", "just ASUFORCE.COM") scopes the work. Check the primary source for licenses.

## Scoring loop

Scoring and refining until every category passes belongs to the `design-score-loop` skill. Run it after the reference round and each adjustment round.

## Short commands

`preview`, `commit`, `advisor review`, `polish` each map to one action. Run them without asking back. `advisor review` after a visual change has caught real defects (a shadow shown with no ghost).
