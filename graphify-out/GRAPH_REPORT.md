# Graph Report - dotfiles  (2026-11-05)

## Corpus Check
- 55 files · ~24,093 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 34 file(s) not represented in the graph (top: (none) 18, .conf 4, .toml 4)

## Summary
- 383 nodes · 472 edges · 55 communities (36 shown, 19 thin omitted)
- Extraction: 96% EXTRACTED · 4% INFERRED · 0% AMBIGUOUS · INFERRED: 21 edges (avg confidence: 0.88)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `a443c70c`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- yomiyasu skill
- codex-herdr-tab-title.py
- llm.sh
- make home-server
- chief-of-staff/SKILL.md
- llm/plugins.tsv
- HookTest
- yomiyasu_lint.py
- design-renewal skill
- home-server.sh
- link.sh
- i-have-adhd skill
- herdr-repo-workspace.sh
- Codex coding delegation under pstack
- Global agent instructions (llm/AGENTS.md)
- restart.sh
- restart.sh script
- clawd.png (Clawd pixel-art icon)
- keybindings.json
- show-me skill
- brew.sh
- Linux package list (Brewfile counterpart)
- Graphify installation and hooks
- Codex does the coding under pstack (codex:codex-rescue)
- before-compact skill
- herdr-tab-title.sh
- defaults.sh
- codex.sh
- xcode.sh
- bootstrap.sh
- Claude status line and permissions
- Design Engineering
- Component Building Principles
- The Animation Decision Framework
- clip-path for Animation
- Performance Rules
- Gesture and Drag Interactions
- CSS Transform Mastery
- The Sonner Principles (Building Loved Components)
- Spring Animations
- Core Philosophy
- Debugging Animations
- pkg.sh
- AGENTS.md
- Herdr integration and tab titles
- mcp-gdrive-auth.mjs
- mcp-gdrive.sh

## God Nodes (most connected - your core abstractions)
1. `HookTest` - 16 edges
2. `Design Engineering` - 16 edges
3. `yomiyasu skill` - 13 edges
4. `main()` - 11 edges
5. `Natural Japanese syntax conversion principles` - 11 edges
6. `lint_text()` - 8 edges
7. `add_defaults()` - 8 edges
8. `Component Building Principles` - 8 edges
9. `Academic and corpus research basis` - 8 edges
10. `llm/plugins.tsv` - 8 edges

## Surprising Connections (you probably didn't know these)
- `No preamble, no recap, no closing pleasantries` --semantically_similar_to--> `Meta declarations and filler`  [INFERRED] [semantically similar]
  llm/skills/i-have-adhd/SKILL.md → llm/skills/yomiyasu/references/slop-catalog.md
- `Total metaphor ban in business docs` --semantically_similar_to--> `Principle 4: figurative verb operationalization`  [INFERRED] [semantically similar]
  llm/skills/yomiyasu/references/domains/business.md → llm/skills/yomiyasu/references/gemini-syntax.md
- `Figurative verb concretization` --conceptually_related_to--> `Principle 4: figurative verb operationalization`  [INFERRED]
  llm/skills/yomiyasu/SKILL.md → llm/skills/yomiyasu/references/gemini-syntax.md
- `Inanimate subject dissolution` --conceptually_related_to--> `Principle 3: inanimate subject dissolution`  [INFERRED]
  llm/skills/yomiyasu/SKILL.md → llm/skills/yomiyasu/references/gemini-syntax.md
- `Self-labeling and negation contrast affirmation` --conceptually_related_to--> `Principle 5: self-labeling and negation contrast`  [INFERRED]
  llm/skills/yomiyasu/SKILL.md → llm/skills/yomiyasu/references/gemini-syntax.md

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **Design renewal and scoring loop** — llm_skills_design_renewal_skill_design_renewal, llm_skills_design_renewal_skill_reference_round, llm_skills_design_renewal_skill_adjustment_round, llm_skills_design_score_loop_skill_design_score_loop, llm_skills_design_score_loop_skill_awwwards_sheet [EXTRACTED 1.00]
- **yomiyasu rewrite references** — llm_skills_yomiyasu_skill_yomiyasu, llm_skills_yomiyasu_references_gemini_syntax_gemini_syntax, llm_skills_yomiyasu_references_slop_catalog_slop_catalog, llm_skills_yomiyasu_references_domains_tech_tech_domain, llm_skills_yomiyasu_references_domains_business_business_domain, llm_skills_yomiyasu_references_domains_essay_essay_domain [INFERRED 0.85]

## Communities (55 total, 19 thin omitted)

### Community 0 - "yomiyasu skill"
Cohesion: 0.06
Nodes (38): No preamble, no recap, no closing pleasantries, Business/spec domain spec, Boundary conditions and responsible subject, Restoring embodiment and personal subject, Essay domain spec, No grandiosity of experience, Bold/bullet inflation limits (bullets <=15%), Restoring procedures and specifics (+30 more)

### Community 1 - "codex-herdr-tab-title.py"
Cohesion: 0.10
Nodes (14): generate(), herdr(), locked(), main(), owned(), read_state(), write_state(), add_defaults() (+6 more)

### Community 2 - "llm.sh"
Cohesion: 0.12
Nodes (13): llm/permissions-allow.json, Individual skill links, Current skill roster, CLAUDE_AGENTS_FILE, CLAUDE_CONFIG_DIR, CLAUDE_SETTINGS_FILE, CLAUDE_SKILLS_DIR, DOTFILES_LLM (+5 more)

### Community 3 - "make home-server"
Cohesion: 0.33
Nodes (6): config/home-server/, make home-server, make personal, mf-dashboard crawler (supercronic), stay-awake command, Night suspend / 05:55 RTC wake schedule

### Community 4 - "chief-of-staff/SKILL.md"
Cohesion: 0.29
Nodes (6): Procedures, Schedules, Strategic View, Subagents, Wiki, Write history, not the present

### Community 5 - "llm/plugins.tsv"
Cohesion: 0.08
Nodes (24): llm/AGENTS.md, autoharness plugin, Codex configuration setup, llm/codex.toml, Dropped skills (review-pr, guide, empirical-prompt-tuning, find-skills, autopilot, asuforce-mode, create-pr, apply-review, create-repo), env plugin, graphify (graphifyy via mise), graphify hook-guard PreToolUse hooks (+16 more)

### Community 6 - "HookTest"
Cohesion: 0.25
Nodes (4): HookTest, generate(), generate(), generate()

### Community 7 - "yomiyasu_lint.py"
Cohesion: 0.25
Nodes (6): analyze_markdown_metrics(), check_sentence_end_repetitions(), extract_plain_sentences(), get_frontmatter_line_count(), lint_text(), main()

### Community 9 - "design-renewal skill"
Cohesion: 0.22
Nodes (10): Adjustment round, DESIGN.md, design-renewal skill, Reference round, Short commands (preview, commit, advisor review, polish), Awwwards scoring sheet, design-score-loop skill, impeccable commands (+2 more)

### Community 10 - "home-server.sh"
Cohesion: 0.28
Nodes (8): CONFIG_HOME, HYPR_BINDINGS, HYPR_MARKER, install_system(), link_user(), home-server.sh script, SRC, USER_NAME

### Community 11 - "link.sh"
Cohesion: 0.53
Nodes (5): adopt_config(), CONFIG_HOME, link_config(), OS, link.sh script

### Community 12 - "i-have-adhd skill"
Cohesion: 0.33
Nodes (5): i-have-adhd skill, Lead with the next action, Persistence until stop adhd mode, Pre-send check, Restate state every turn

### Community 13 - "herdr-repo-workspace.sh"
Cohesion: 0.53
Nodes (4): equalize_columns(), is_worktree(), repo_name_of(), herdr-repo-workspace.sh script

### Community 14 - "Codex coding delegation under pstack"
Cohesion: 0.33
Nodes (5): Codex coding delegation under pstack, Codex model and effort by task, Verify delegated Codex work, Claude plugin installation, pstack routing and priority

### Community 15 - "Global agent instructions (llm/AGENTS.md)"
Cohesion: 0.50
Nodes (3): Closing headings Blocked on me / Changed / Found, Global agent instructions (llm/AGENTS.md), ~/.claude/pstack-models.md import

### Community 16 - "restart.sh"
Cohesion: 0.70
Nodes (4): claude_proc(), keep_reason(), process_session(), restart.sh script

### Community 17 - "restart.sh script"
Cohesion: 0.40
Nodes (4): autoharness reflector, claude-restart skill, herdr pane, restart.sh script

### Community 18 - "clawd.png (Clawd pixel-art icon)"
Cohesion: 0.50
Nodes (4): clawd.png (Clawd pixel-art icon), Claude brand orange #D97757, Go-to-bed notification icon, Clawd mascot (Claude Code pixel-art character)

### Community 19 - "keybindings.json"
Cohesion: 0.50
Nodes (3): bindings, $docs, $schema

### Community 20 - "show-me skill"
Cohesion: 0.50
Nodes (3): Focused HTML visual file, show-me skill, Text visuals (pseudocode, call tree, file tree, Mermaid, diff)

### Community 21 - "brew.sh"
Cohesion: 0.50
Nodes (3): BREW, GH, brew.sh script

### Community 24 - "Linux package list (Brewfile counterpart)"
Cohesion: 0.67
Nodes (3): HackGen font (fetched by scripts/pkg.sh), omarchy pkg add, Linux package list (Brewfile counterpart)

### Community 25 - "Graphify installation and hooks"
Cohesion: 0.67
Nodes (3): Graphify usage rules, Shared graphify artifacts, Graphify installation and hooks

### Community 35 - "bootstrap.sh"
Cohesion: 0.33
Nodes (5): Make targets (all, link, brew, pkg, macos, llm, runtime, xcode), README.md (dotfiles usage), GITHUB_DIR, REPO_DIR, bootstrap.sh script

### Community 39 - "Design Engineering"
Cohesion: 0.22
Nodes (8): Accessibility, Design Engineering, Initial Response, prefers-reduced-motion, Review Checklist, Review Format (Required), Stagger Animations, Touch device hover states

### Community 40 - "Component Building Principles"
Cohesion: 0.25
Nodes (8): Animate enter states with @starting-style, Buttons must feel responsive, Component Building Principles, Make popovers origin-aware, Never animate from scale(0), Tooltips: skip delay on subsequent hovers, Use blur to mask imperfect transitions, Use CSS transitions over keyframes for interruptible UI

### Community 41 - "The Animation Decision Framework"
Cohesion: 0.33
Nodes (6): 1. Should this animate at all?, 2. What is the purpose?, 3. What easing should it use?, 4. How fast should it be?, Perceived performance, The Animation Decision Framework

### Community 42 - "clip-path for Animation"
Cohesion: 0.33
Nodes (6): clip-path for Animation, Comparison sliders, Hold-to-delete pattern, Image reveals on scroll, Tabs with perfect color transitions, The inset shape

### Community 43 - "Performance Rules"
Cohesion: 0.33
Nodes (6): CSS animations beat JS under load, CSS variables are inheritable, Framer Motion hardware acceleration caveat, Only animate transform and opacity, Performance Rules, Use WAAPI for programmatic CSS animations

### Community 44 - "Gesture and Drag Interactions"
Cohesion: 0.33
Nodes (6): Damping at boundaries, Friction instead of hard stops, Gesture and Drag Interactions, Momentum-based dismissal, Multi-touch protection, Pointer capture for drag

### Community 45 - "CSS Transform Mastery"
Cohesion: 0.40
Nodes (5): 3D transforms for depth, CSS Transform Mastery, scale() scales children too, transform-origin, translateY with percentages

### Community 46 - "The Sonner Principles (Building Loved Components)"
Cohesion: 0.40
Nodes (5): Asymmetric enter/exit timing, Cohesion matters, Review your work the next day, The opacity + height combination, The Sonner Principles (Building Loved Components)

### Community 47 - "Spring Animations"
Cohesion: 0.40
Nodes (5): Interruptibility advantage, Spring Animations, Spring-based mouse interactions, Spring configuration, When to use springs

### Community 48 - "Core Philosophy"
Cohesion: 0.50
Nodes (4): Beauty is leverage, Core Philosophy, Taste is trained, not innate, Unseen details compound

### Community 49 - "Debugging Animations"
Cohesion: 0.50
Nodes (4): Debugging Animations, Frame-by-frame inspection, Slow motion testing, Test on real devices

### Community 50 - "pkg.sh"
Cohesion: 0.40
Nodes (4): FONT_DIR, HACKGEN_VERSION, LIST, pkg.sh script

## Knowledge Gaps
- **76 isolated node(s):** `GITHUB_DIR`, `REPO_DIR`, `BREW`, `GH`, `SRC` (+71 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 198 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **19 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `yomiyasu skill` connect `yomiyasu skill` to `yomiyasu_lint.py`?**
  _High betweenness centrality (0.066) - this node is a cross-community bridge._
- **Are the 4 inferred relationships involving `yomiyasu skill` (e.g. with `Business/spec domain spec` and `Essay domain spec`) actually correct?**
  _`yomiyasu skill` has 4 INFERRED edges - model-reasoned connections that need verification._
- **What connects `GITHUB_DIR`, `REPO_DIR`, `BREW` to the rest of the system?**
  _76 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `yomiyasu skill` be split into smaller, more focused modules?**
  _Cohesion score 0.06387921022067364 - nodes in this community are weakly interconnected._
- **Why does `HookTest` connect `HookTest` to `codex-herdr-tab-title.py`?**
  _High betweenness centrality (0.029) - this node is a cross-community bridge._
- **Should `codex-herdr-tab-title.py` be split into smaller, more focused modules?**
  _Cohesion score 0.09743589743589744 - nodes in this community are weakly interconnected._
- **Why does `Design Engineering` connect `Design Engineering` to `Component Building Principles`, `The Animation Decision Framework`, `clip-path for Animation`, `Performance Rules`, `Gesture and Drag Interactions`, `CSS Transform Mastery`, `The Sonner Principles (Building Loved Components)`, `Spring Animations`, `Core Philosophy`, `Debugging Animations`?**
  _High betweenness centrality (0.025) - this node is a cross-community bridge._