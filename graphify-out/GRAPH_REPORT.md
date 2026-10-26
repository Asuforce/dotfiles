# Graph Report - dotfiles  (2026-10-26)

## Corpus Check
- Corpus is ~24,364 words - fits in a single context window. You may not need a graph.

## Summary
- 310 nodes · 419 edges · 38 communities (21 shown, 17 thin omitted)
- Extraction: 93% EXTRACTED · 7% INFERRED · 0% AMBIGUOUS · INFERRED: 30 edges (avg confidence: 0.85)
- Token cost: 268,244 input · 0 output

## Community Hubs (Navigation)
- Japanese Writing Rules
- Dotfiles Architecture Principles
- Codex Tab Title Hook
- Grilling and ADR Records
- Terminal and Package Ownership
- Tab Title Hook Tests
- Yomiyasu Linter
- Codex Install Tests
- Design Renewal Loop
- Home Server Setup
- Codex Delegation and Jev
- ADHD Reply Mode
- Herdr Repo Workspace
- Config Linking
- Claude Restart Script
- Claude Restart Skill
- Linux Package Install
- Clawd Mascot Image
- Claude Keybindings
- Show-me Visuals
- Bootstrap Script
- Homebrew Setup
- Memory Before Compact
- Mise Runtimes
- Omarchy Pending Checks
- Herdr Tab Title
- Status Line
- macOS Defaults
- Codex Setup Script
- Xcode Setup

## God Nodes (most connected - your core abstractions)
1. `HookTest` - 14 edges
2. `yomiyasu skill` - 13 edges
3. `main()` - 11 edges
4. `Natural Japanese syntax conversion principles` - 11 edges
5. `grill-with-docs skill` - 9 edges
6. `lint_text()` - 8 edges
7. `add_defaults()` - 8 edges
8. `Academic and corpus research basis` - 8 edges
9. `i-have-adhd skill` - 7 edges
10. `generate()` - 6 edges

## Surprising Connections (you probably didn't know these)
- `autopilot skill (auto-merge, personal repos only)` --semantically_similar_to--> `pstack takes precedence over CLAUDE.md`  [INFERRED] [semantically similar]
  docs/poc/autopilot/2026-10-04-autopilot-scope-and-gates.md → llm/pstack-priority.md
- `Migration pre-filter pattern (migration-scan.py + Jev)` --semantically_similar_to--> `Codex does the coding under pstack (codex:codex-rescue)`  [INFERRED] [semantically similar]
  docs/poc/jev-integration/2026-09-28-migration-prefilter.md → llm/pstack-codex.md
- `Parallelize via herdr panes only for 2+ independent units` --conceptually_related_to--> `herdr integration hooks (repo-workspace, tab-title)`  [INFERRED]
  docs/poc/autopilot/2026-10-04-autopilot-scope-and-gates.md → llm/README.md
- `Migration pre-filter pattern (migration-scan.py + Jev)` --conceptually_related_to--> `Skills only, no commands`  [INFERRED]
  docs/poc/jev-integration/2026-09-28-migration-prefilter.md → llm/README.md
- `grill-me skill` --semantically_similar_to--> `grill-with-docs skill`  [INFERRED] [semantically similar]
  llm/skills/grill-me/SKILL.md → llm/skills/grill-with-docs/SKILL.md

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **omarchy config precedence handling** — docs_poc_omarchy4_migration_2026_10_01_status_for_omarchy_agent_per_app_precedence, docs_poc_omarchy4_migration_2026_10_01_status_for_omarchy_agent_adopt_config, docs_poc_omarchy4_migration_2026_10_01_status_for_omarchy_agent_link_config, claude_omarchy_linux_target [EXTRACTED 1.00]
- **pstack rule layering over CLAUDE.md** — llm_readme_pstack_plugin, llm_pstack_priority_pstack_precedence, llm_pstack_codex_codex_delegation, llm_agents_pstack_models, llm_agents_global_instructions [EXTRACTED 1.00]
- **Opt-in targets kept out of make all** — readme_home_server, readme_make_personal, claude_brewfile_personal_gate [INFERRED 0.85]
- **grill-with-docs decision record and glossary formats** — llm_skills_grill_with_docs_skill_grill_with_docs, llm_skills_grill_with_docs_adr_format_adr_format, llm_skills_grill_with_docs_poc_format_poc_format, llm_skills_grill_with_docs_context_format_context_format [EXTRACTED 1.00]
- **yomiyasu rewrite references** — llm_skills_yomiyasu_skill_yomiyasu, llm_skills_yomiyasu_references_gemini_syntax_gemini_syntax, llm_skills_yomiyasu_references_slop_catalog_slop_catalog, llm_skills_yomiyasu_references_domains_tech_tech_domain, llm_skills_yomiyasu_references_domains_business_business_domain, llm_skills_yomiyasu_references_domains_essay_essay_domain [INFERRED 0.85]
- **Design renewal and scoring loop** — llm_skills_design_renewal_skill_design_renewal, llm_skills_design_renewal_skill_reference_round, llm_skills_design_renewal_skill_adjustment_round, llm_skills_design_score_loop_skill_design_score_loop, llm_skills_design_score_loop_skill_awwwards_sheet [EXTRACTED 1.00]

## Communities (38 total, 17 thin omitted)

### Community 0 - "Japanese Writing Rules"
Cohesion: 0.06
Nodes (38): No preamble, no recap, no closing pleasantries, Business/spec domain spec, Boundary conditions and responsible subject, Restoring embodiment and personal subject, Essay domain spec, No grandiosity of experience, Bold/bullet inflation limits (bullets <=15%), Restoring procedures and specifics (+30 more)

### Community 1 - "Dotfiles Architecture Principles"
Cohesion: 0.08
Nodes (28): Dotfiles symlink architecture (config/ + scripts/link.sh), autopilot skill (auto-merge, personal repos only), Closing headings Blocked on me / Changed / Found, Global agent instructions (llm/AGENTS.md), ~/.claude/pstack-models.md import, AutoHarness plugin, codex-herdr-tab-title.py hook, Codex setup (scripts/codex.sh) (+20 more)

### Community 2 - "Codex Tab Title Hook"
Cohesion: 0.16
Nodes (13): generate(), herdr(), locked(), main(), owned(), read_state(), write_state(), add_defaults() (+5 more)

### Community 3 - "Grilling and ADR Records"
Cohesion: 0.13
Nodes (12): grill-me skill, ADR Format, Sequential ADR numbering in docs/adr, What qualifies as an ADR, CONTEXT.md Format, Single vs multi-context repos, Cleanup pass (promote to ADR, absorb into CONTEXT.md, delete), PoC Decision Log Format (+4 more)

### Community 4 - "Terminal and Package Ownership"
Cohesion: 0.12
Nodes (15): Brewfile 'if personal' gating via ~/.config/dotfiles/personal marker, Ghostty terminal (kitty keyboard + graphics protocols), omarchy (Arch Linux) target via uname -s branching, HackGen font (fetched by scripts/pkg.sh), omarchy pkg add, Linux package list (Brewfile counterpart), adopt_config (replace omarchy seeded file then link), link_config ('skipped, already exists') (+7 more)

### Community 5 - "Tab Title Hook Tests"
Cohesion: 0.29
Nodes (4): HookTest, generate(), generate(), generate()

### Community 6 - "Yomiyasu Linter"
Cohesion: 0.25
Nodes (6): analyze_markdown_metrics(), check_sentence_end_repetitions(), extract_plain_sentences(), get_frontmatter_line_count(), lint_text(), main()

### Community 9 - "Design Renewal Loop"
Cohesion: 0.22
Nodes (10): Adjustment round, DESIGN.md, design-renewal skill, Reference round, Short commands (preview, commit, advisor review, polish), Awwwards scoring sheet, design-score-loop skill, impeccable commands (+2 more)

### Community 10 - "Home Server Setup"
Cohesion: 0.28
Nodes (8): CONFIG_HOME, HYPR_BINDINGS, HYPR_MARKER, install_system(), link_user(), home-server.sh script, SRC, USER_NAME

### Community 11 - "Codex Delegation and Jev"
Cohesion: 0.29
Nodes (3): Jev (TypeSafe AI typed-decision model), Migration pre-filter pattern (migration-scan.py + Jev), Codex does the coding under pstack (codex:codex-rescue)

### Community 12 - "ADHD Reply Mode"
Cohesion: 0.33
Nodes (5): i-have-adhd skill, Lead with the next action, Persistence until stop adhd mode, Pre-send check, Restate state every turn

### Community 13 - "Herdr Repo Workspace"
Cohesion: 0.53
Nodes (4): equalize_columns(), is_worktree(), repo_name_of(), herdr-repo-workspace.sh script

### Community 14 - "Config Linking"
Cohesion: 0.53
Nodes (5): adopt_config(), CONFIG_HOME, link_config(), OS, link.sh script

### Community 15 - "Claude Restart Script"
Cohesion: 0.70
Nodes (4): claude_proc(), keep_reason(), process_session(), restart.sh script

### Community 16 - "Claude Restart Skill"
Cohesion: 0.40
Nodes (4): autoharness reflector, claude-restart skill, herdr pane, restart.sh script

### Community 17 - "Linux Package Install"
Cohesion: 0.40
Nodes (4): FONT_DIR, HACKGEN_VERSION, LIST, pkg.sh script

### Community 18 - "Clawd Mascot Image"
Cohesion: 0.50
Nodes (4): clawd.png (Clawd pixel-art icon), Claude brand orange #D97757, Go-to-bed notification icon, Clawd mascot (Claude Code pixel-art character)

### Community 19 - "Claude Keybindings"
Cohesion: 0.50
Nodes (3): bindings, $docs, $schema

### Community 20 - "Show-me Visuals"
Cohesion: 0.50
Nodes (3): Focused HTML visual file, show-me skill, Text visuals (pseudocode, call tree, file tree, Mermaid, diff)

### Community 21 - "Bootstrap Script"
Cohesion: 0.50
Nodes (3): GITHUB_DIR, REPO_DIR, bootstrap.sh script

### Community 22 - "Homebrew Setup"
Cohesion: 0.50
Nodes (3): BREW, GH, brew.sh script

## Knowledge Gaps
- **68 isolated node(s):** `GITHUB_DIR`, `REPO_DIR`, `BREW`, `GH`, `SRC` (+63 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 136 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **17 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `yomiyasu skill` connect `Japanese Writing Rules` to `Yomiyasu Linter`?**
  _High betweenness centrality (0.097) - this node is a cross-community bridge._
- **Are the 4 inferred relationships involving `yomiyasu skill` (e.g. with `Business/spec domain spec` and `Essay domain spec`) actually correct?**
  _`yomiyasu skill` has 4 INFERRED edges - model-reasoned connections that need verification._
- **What connects `GITHUB_DIR`, `REPO_DIR`, `BREW` to the rest of the system?**
  _68 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Japanese Writing Rules` be split into smaller, more focused modules?**
  _Cohesion score 0.06387921022067364 - nodes in this community are weakly interconnected._
- **Why does `HookTest` connect `Tab Title Hook Tests` to `Codex Install Tests`?**
  _High betweenness centrality (0.039) - this node is a cross-community bridge._
- **Should `Dotfiles Architecture Principles` be split into smaller, more focused modules?**
  _Cohesion score 0.0773109243697479 - nodes in this community are weakly interconnected._
- **Should `Grilling and ADR Records` be split into smaller, more focused modules?**
  _Cohesion score 0.12631578947368421 - nodes in this community are weakly interconnected._