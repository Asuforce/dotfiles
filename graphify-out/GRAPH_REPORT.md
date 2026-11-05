# Graph Report - dotfiles  (2026-11-05)

## Corpus Check
- 59 files · ~27,444 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 34 file(s) not represented in the graph (top: (none) 18, .conf 4, .toml 4)

## Summary
- 410 nodes · 520 edges · 56 communities (38 shown, 18 thin omitted)
- Extraction: 95% EXTRACTED · 5% INFERRED · 0% AMBIGUOUS · INFERRED: 28 edges (avg confidence: 0.88)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `7ad0688e`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- yomiyasu skill
- codex-herdr-tab-title.py
- llm.sh
- CLAUDE.md (project instructions)
- grill-with-docs skill
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
- llm/AGENTS.md
- Vendored skills and upstream review
- graphify (graphifyy via mise)
- herdr (terminal multiplexer)
- mcp-gdrive-auth.mjs
- mcp-gdrive.sh

## God Nodes (most connected - your core abstractions)
1. `HookTest` - 16 edges
2. `Design Engineering` - 16 edges
3. `yomiyasu skill` - 13 edges
4. `main()` - 11 edges
5. `Natural Japanese syntax conversion principles` - 11 edges
6. `grill-with-docs skill` - 9 edges
7. `llm/plugins.tsv` - 9 edges
8. `add_defaults()` - 8 edges
9. `lint_text()` - 8 edges
10. `Component Building Principles` - 8 edges

## Surprising Connections (you probably didn't know these)
- `graphify hook-guard PreToolUse hooks` --semantically_similar_to--> `Fail-open hooks (llm/hooks/)`  [INFERRED] [semantically similar]
  llm/README.md → CLAUDE.md
- `Delegation through pstack` --references--> `pstack plugin (cursor/plugins)`  [EXTRACTED]
  CLAUDE.md → llm/README.md
- `graphify (graphifyy via mise)` --references--> `mise`  [EXTRACTED]
  llm/README.md → CLAUDE.md
- `grill-me skill` --semantically_similar_to--> `grill-with-docs skill`  [INFERRED] [semantically similar]
  llm/skills/grill-me/SKILL.md → llm/skills/grill-with-docs/SKILL.md
- `CLAUDE.md (project instructions)` --references--> `llm/pstack-priority.md`  [EXTRACTED]
  CLAUDE.md → llm/README.md

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **Design renewal and scoring loop** — llm_skills_design_renewal_skill_design_renewal, llm_skills_design_renewal_skill_reference_round, llm_skills_design_renewal_skill_adjustment_round, llm_skills_design_score_loop_skill_design_score_loop, llm_skills_design_score_loop_skill_awwwards_sheet [EXTRACTED 1.00]
- **grill-with-docs decision record and glossary formats** — llm_skills_grill_with_docs_skill_grill_with_docs, llm_skills_grill_with_docs_adr_format_adr_format, llm_skills_grill_with_docs_poc_format_poc_format, llm_skills_grill_with_docs_context_format_context_format [EXTRACTED 1.00]
- **Terminal stack: herdr on Ghostty** — claude_herdr, claude_ghostty, claude_ghostty_config, claude_herdr_config_toml, claude_kitty_protocols [EXTRACTED 1.00]
- **Opt-in setups kept out of make all** — readme_make_personal, readme_make_home_server, claude_personal_marker, readme_make_targets [INFERRED 0.85]
- **yomiyasu rewrite references** — llm_skills_yomiyasu_skill_yomiyasu, llm_skills_yomiyasu_references_gemini_syntax_gemini_syntax, llm_skills_yomiyasu_references_slop_catalog_slop_catalog, llm_skills_yomiyasu_references_domains_tech_tech_domain, llm_skills_yomiyasu_references_domains_business_business_domain, llm_skills_yomiyasu_references_domains_essay_essay_domain [INFERRED 0.85]

## Communities (56 total, 18 thin omitted)

### Community 0 - "yomiyasu skill"
Cohesion: 0.06
Nodes (38): No preamble, no recap, no closing pleasantries, Business/spec domain spec, Boundary conditions and responsible subject, Restoring embodiment and personal subject, Essay domain spec, No grandiosity of experience, Bold/bullet inflation limits (bullets <=15%), Restoring procedures and specifics (+30 more)

### Community 1 - "codex-herdr-tab-title.py"
Cohesion: 0.10
Nodes (14): generate(), herdr(), locked(), main(), owned(), read_state(), write_state(), add_defaults() (+6 more)

### Community 2 - "llm.sh"
Cohesion: 0.15
Nodes (12): Herdr integration and tab titles, llm/permissions-allow.json, CLAUDE_AGENTS_FILE, CLAUDE_CONFIG_DIR, CLAUDE_SETTINGS_FILE, CLAUDE_SKILLS_DIR, DOTFILES_LLM, KEYBINDINGS_DEST (+4 more)

### Community 3 - "CLAUDE.md (project instructions)"
Cohesion: 0.09
Nodes (21): Brewfile, CLAUDE.md (project instructions), config/packages/linux.txt, Makefile, omarchy (Arch Linux) target, Symlink-based dotfiles architecture, config/home-server/, make home-server (+13 more)

### Community 4 - "grill-with-docs skill"
Cohesion: 0.13
Nodes (12): grill-me skill, ADR Format, Sequential ADR numbering in docs/adr, What qualifies as an ADR, CONTEXT.md Format, Single vs multi-context repos, Cleanup pass (promote to ADR, absorb into CONTEXT.md, delete), PoC Decision Log Format (+4 more)

### Community 5 - "llm/plugins.tsv"
Cohesion: 0.24
Nodes (9): autoharness plugin, env plugin, mission-control mod, llm/plugins.tsv, pstack plugin (cursor/plugins), token-weather mod, usage-meter mod, cc-plugin-you-should-know (+1 more)

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
Cohesion: 0.43
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

### Community 50 - "llm/AGENTS.md"
Cohesion: 0.22
Nodes (7): llm/AGENTS.md, Codex configuration setup, llm/codex.toml, impeccable plugin, MCP definitions and Codex profiles (coding/browser/infra), ~/.claude/pstack-models.md, show-me visual skill

### Community 51 - "Vendored skills and upstream review"
Cohesion: 0.25
Nodes (6): Dropped skills (review-pr, guide, empirical-prompt-tuning, find-skills, autopilot, asuforce-mode, create-pr, apply-review, create-repo), i-have-adhd skill (ayghri/i-have-adhd), Individual skill links, Current skill roster, Vendored skills and upstream review, yomiyasu skill (nanaism/yomiyasu)

### Community 52 - "graphify (graphifyy via mise)"
Cohesion: 0.33
Nodes (5): mise, graphify (graphifyy via mise), graphify hook-guard PreToolUse hooks, MISE_CONFIG_FILE, runtime.sh script

### Community 53 - "herdr (terminal multiplexer)"
Cohesion: 0.38
Nodes (6): Ghostty, config/ghostty/config.ghostty, Hammerspoon Option+Space hotkey, herdr (terminal multiplexer), config/herdr/config.toml, kitty keyboard and graphics protocols

## Knowledge Gaps
- **80 isolated node(s):** `OS`, `CONFIG_HOME`, `CLAUDE_CONFIG_DIR`, `DOTFILES_LLM`, `CLAUDE_AGENTS_FILE` (+75 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 201 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **18 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `yomiyasu skill` connect `yomiyasu skill` to `yomiyasu_lint.py`?**
  _High betweenness centrality (0.057) - this node is a cross-community bridge._
- **Are the 4 inferred relationships involving `yomiyasu skill` (e.g. with `Business/spec domain spec` and `Essay domain spec`) actually correct?**
  _`yomiyasu skill` has 4 INFERRED edges - model-reasoned connections that need verification._
- **What connects `OS`, `CONFIG_HOME`, `CLAUDE_CONFIG_DIR` to the rest of the system?**
  _80 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `yomiyasu skill` be split into smaller, more focused modules?**
  _Cohesion score 0.06387921022067364 - nodes in this community are weakly interconnected._
- **Why does `HookTest` connect `HookTest` to `codex-herdr-tab-title.py`?**
  _High betweenness centrality (0.026) - this node is a cross-community bridge._
- **Should `codex-herdr-tab-title.py` be split into smaller, more focused modules?**
  _Cohesion score 0.09743589743589744 - nodes in this community are weakly interconnected._
- **Why does `CLAUDE.md (project instructions)` connect `CLAUDE.md (project instructions)` to `Vendored skills and upstream review`?**
  _High betweenness centrality (0.022) - this node is a cross-community bridge._