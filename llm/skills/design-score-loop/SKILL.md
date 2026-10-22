---
name: design-score-loop
description: Use when asked to score a design and keep refining it until it passes, or to polish a page against Awwwards criteria.
---

# Design score loop

Refine a page in rounds, scoring each round on the Awwwards sheet until every category clears the bar.

## Sheet

Design 40%, usability 30%, creativity 20%, content 10%. Each category scores out of 10. Grade like a strict real judge: a 10 is rare, and a score is not raised for effort.

Content is fixed by the user's facts. Score it, but do not edit copy to lift it, since an open content axis makes the agent pad copy and add decoration.

## Round

1. Run the page and take a screenshot at the size it ships at. If the page cannot run, say so before scoring.
2. Score while looking at the screenshot, never from the code alone. Print the four scores and the weighted total.
3. Name what holds back the lowest category, in one concrete visual observation.
4. Fix that cause and nothing else. When `impeccable` is installed, use the matching command (`layout`, `typeset`, `colorize`, `distill`, `animate`) instead of editing by hand.
5. Start the next round from step 1.

## Stop

- Stop when every category is 7.5 or higher.
- Stop after 5 rounds even if one is below, and report the lowest category with its cause. Ask whether to continue.
- Stop and ask once if two rounds in a row leave the lowest category unchanged.

## Report

One line per round: scores, the lowest category, the fix. End with the final scores and what is still weakest.
