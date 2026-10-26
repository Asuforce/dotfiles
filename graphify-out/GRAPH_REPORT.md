# Graph Report - dotfiles  (2026-10-26)

## Corpus Check
- 59 files · ~23,016 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 323 nodes · 442 edges · 36 communities (21 shown, 15 thin omitted)
- Extraction: 93% EXTRACTED · 7% INFERRED · 0% AMBIGUOUS · INFERRED: 30 edges (avg confidence: 0.87)
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- Agent Tooling Setup
- Japanese Writing Rules
- Codex Tab Title Hook
- Cross-OS Setup
- Grilling and ADR Records
- Tab Title Hook Tests
- Yomiyasu Linter
- Codex Install Tests
- Design Renewal Loop
- Terminal Stack
- Home Server Setup
- Config Linking
- ADHD Reply Mode
- Herdr Repo Workspace
- Dotfiles Architecture Principles
- Claude Restart Script
- Claude Restart Skill
- Clawd Mascot Image
- Claude Keybindings
- Show-me Visuals
- Homebrew Setup
- Terminal and Package Ownership
- Codex Delegation
- Memory Before Compact
- macOS Defaults
- Codex Setup Script
- Xcode Setup

## God Nodes (most connected - your core abstractions)
1. `HookTest` - 14 edges
2. `yomiyasu skill` - 13 edges
3. `main()` - 11 edges
4. `Natural Japanese syntax conversion principles` - 11 edges
5. `grill-with-docs skill` - 9 edges
6. `llm/plugins.tsv` - 9 edges
7. `add_defaults()` - 8 edges
8. `lint_text()` - 8 edges
9. `Academic and corpus research basis` - 8 edges
10. `i-have-adhd skill` - 7 edges

## Surprising Connections (you probably didn't know these)
- `graphify hook-guard PreToolUse hooks` --semantically_similar_to--> `Fail-open hooks (llm/hooks/)`  [INFERRED] [semantically similar]
  llm/README.md → CLAUDE.md
- `Vendored skills (llm/upstream-skills.tsv)` --semantically_similar_to--> `Fail-open hooks (llm/hooks/)`  [INFERRED] [semantically similar]
  llm/README.md → CLAUDE.md
- `grill-me skill` --semantically_similar_to--> `grill-with-docs skill`  [INFERRED] [semantically similar]
  llm/skills/grill-me/SKILL.md → llm/skills/grill-with-docs/SKILL.md
- `CLAUDE.md (project instructions)` --references--> `llm/pstack-priority.md`  [EXTRACTED]
  CLAUDE.md → llm/README.md
- `graphify (graphifyy via mise)` --references--> `mise`  [EXTRACTED]
  llm/README.md → CLAUDE.md

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **Design renewal and scoring loop** — llm_skills_design_renewal_skill_design_renewal, llm_skills_design_renewal_skill_reference_round, llm_skills_design_renewal_skill_adjustment_round, llm_skills_design_score_loop_skill_design_score_loop, llm_skills_design_score_loop_skill_awwwards_sheet [EXTRACTED 1.00]
- **grill-with-docs decision record and glossary formats** — llm_skills_grill_with_docs_skill_grill_with_docs, llm_skills_grill_with_docs_adr_format_adr_format, llm_skills_grill_with_docs_poc_format_poc_format, llm_skills_grill_with_docs_context_format_context_format [EXTRACTED 1.00]
- **yomiyasu rewrite references** — llm_skills_yomiyasu_skill_yomiyasu, llm_skills_yomiyasu_references_gemini_syntax_gemini_syntax, llm_skills_yomiyasu_references_slop_catalog_slop_catalog, llm_skills_yomiyasu_references_domains_tech_tech_domain, llm_skills_yomiyasu_references_domains_business_business_domain, llm_skills_yomiyasu_references_domains_essay_essay_domain [INFERRED 0.85]
- **Opt-in setups kept out of make all** — readme_make_personal, readme_make_home_server, claude_personal_marker, readme_make_targets [INFERRED 0.85]
- **Terminal stack: herdr on Ghostty** — claude_herdr, claude_ghostty, claude_ghostty_config, claude_herdr_config_toml, claude_kitty_protocols [EXTRACTED 1.00]
- **pstack precedence and model routing** — llm_readme_pstack, llm_readme_pstack_priority_md, llm_readme_pstack_codex_md, llm_readme_pstack_models_md, llm_readme_agents_md [EXTRACTED 1.00]

## Communities (36 total, 15 thin omitted)

### Community 0 - "Agent Tooling Setup"
Cohesion: 0.06
Nodes (37): mise, llm/AGENTS.md, autoharness plugin, Codex setup (scripts/codex.sh), llm/codex.toml, Dropped skills (review-pr, guide, empirical-prompt-tuning, find-skills, autopilot, asuforce-mode, create-pr, apply-review, create-repo), env plugin, graphify (graphifyy via mise) (+29 more)

### Community 1 - "Japanese Writing Rules"
Cohesion: 0.06
Nodes (38): No preamble, no recap, no closing pleasantries, Business/spec domain spec, Boundary conditions and responsible subject, Restoring embodiment and personal subject, Essay domain spec, No grandiosity of experience, Bold/bullet inflation limits (bullets <=15%), Restoring procedures and specifics (+30 more)

### Community 2 - "Codex Tab Title Hook"
Cohesion: 0.16
Nodes (13): generate(), herdr(), locked(), main(), owned(), read_state(), write_state(), add_defaults() (+5 more)

### Community 3 - "Cross-OS Setup"
Cohesion: 0.09
Nodes (21): Brewfile, CLAUDE.md (project instructions), config/packages/linux.txt, Makefile, omarchy (Arch Linux) target, Symlink-based dotfiles architecture, config/home-server/, make home-server (+13 more)

### Community 4 - "Grilling and ADR Records"
Cohesion: 0.13
Nodes (12): grill-me skill, ADR Format, Sequential ADR numbering in docs/adr, What qualifies as an ADR, CONTEXT.md Format, Single vs multi-context repos, Cleanup pass (promote to ADR, absorb into CONTEXT.md, delete), PoC Decision Log Format (+4 more)

### Community 5 - "Tab Title Hook Tests"
Cohesion: 0.29
Nodes (4): HookTest, generate(), generate(), generate()

### Community 6 - "Yomiyasu Linter"
Cohesion: 0.25
Nodes (6): analyze_markdown_metrics(), check_sentence_end_repetitions(), extract_plain_sentences(), get_frontmatter_line_count(), lint_text(), main()

### Community 9 - "Design Renewal Loop"
Cohesion: 0.22
Nodes (10): Adjustment round, DESIGN.md, design-renewal skill, Reference round, Short commands (preview, commit, advisor review, polish), Awwwards scoring sheet, design-score-loop skill, impeccable commands (+2 more)

### Community 10 - "Terminal Stack"
Cohesion: 0.28
Nodes (8): Ghostty, config/ghostty/config.ghostty, Hammerspoon Option+Space hotkey, herdr (terminal multiplexer), config/herdr/config.toml, kitty keyboard and graphics protocols, herdr-tab-title.sh script, herdr integration (herdr-repo-workspace.sh)

### Community 11 - "Home Server Setup"
Cohesion: 0.28
Nodes (8): CONFIG_HOME, HYPR_BINDINGS, HYPR_MARKER, install_system(), link_user(), home-server.sh script, SRC, USER_NAME

### Community 12 - "Config Linking"
Cohesion: 0.43
Nodes (5): adopt_config(), CONFIG_HOME, link_config(), OS, link.sh script

### Community 13 - "ADHD Reply Mode"
Cohesion: 0.33
Nodes (5): i-have-adhd skill, Lead with the next action, Persistence until stop adhd mode, Pre-send check, Restate state every turn

### Community 14 - "Herdr Repo Workspace"
Cohesion: 0.53
Nodes (4): equalize_columns(), is_worktree(), repo_name_of(), herdr-repo-workspace.sh script

### Community 15 - "Dotfiles Architecture Principles"
Cohesion: 0.50
Nodes (3): Closing headings Blocked on me / Changed / Found, Global agent instructions (llm/AGENTS.md), ~/.claude/pstack-models.md import

### Community 16 - "Claude Restart Script"
Cohesion: 0.70
Nodes (4): claude_proc(), keep_reason(), process_session(), restart.sh script

### Community 17 - "Claude Restart Skill"
Cohesion: 0.40
Nodes (4): autoharness reflector, claude-restart skill, herdr pane, restart.sh script

### Community 18 - "Clawd Mascot Image"
Cohesion: 0.50
Nodes (4): clawd.png (Clawd pixel-art icon), Claude brand orange #D97757, Go-to-bed notification icon, Clawd mascot (Claude Code pixel-art character)

### Community 19 - "Claude Keybindings"
Cohesion: 0.50
Nodes (3): bindings, $docs, $schema

### Community 20 - "Show-me Visuals"
Cohesion: 0.50
Nodes (3): Focused HTML visual file, show-me skill, Text visuals (pseudocode, call tree, file tree, Mermaid, diff)

### Community 21 - "Homebrew Setup"
Cohesion: 0.50
Nodes (3): BREW, GH, brew.sh script

### Community 24 - "Terminal and Package Ownership"
Cohesion: 0.67
Nodes (3): HackGen font (fetched by scripts/pkg.sh), omarchy pkg add, Linux package list (Brewfile counterpart)

## Knowledge Gaps
- **71 isolated node(s):** `CLAUDE_AGENTS_FILE`, `CLAUDE_CONFIG_DIR`, `CLAUDE_SETTINGS_FILE`, `CLAUDE_SKILLS_DIR`, `DOTFILES_LLM` (+66 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 132 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **15 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `yomiyasu skill` connect `Japanese Writing Rules` to `Yomiyasu Linter`?**
  _High betweenness centrality (0.169) - this node is a cross-community bridge._
- **Are the 4 inferred relationships involving `yomiyasu skill` (e.g. with `Business/spec domain spec` and `Essay domain spec`) actually correct?**
  _`yomiyasu skill` has 4 INFERRED edges - model-reasoned connections that need verification._
- **What connects `CLAUDE_AGENTS_FILE`, `CLAUDE_CONFIG_DIR`, `CLAUDE_SETTINGS_FILE` to the rest of the system?**
  _71 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Agent Tooling Setup` be split into smaller, more focused modules?**
  _Cohesion score 0.05555555555555555 - nodes in this community are weakly interconnected._
- **Why does `Codex setup (scripts/codex.sh)` connect `Agent Tooling Setup` to `Codex Tab Title Hook`?**
  _High betweenness centrality (0.145) - this node is a cross-community bridge._
- **Should `Japanese Writing Rules` be split into smaller, more focused modules?**
  _Cohesion score 0.06387921022067364 - nodes in this community are weakly interconnected._
- **Should `Cross-OS Setup` be split into smaller, more focused modules?**
  _Cohesion score 0.09333333333333334 - nodes in this community are weakly interconnected._