# Graph Report - dotfiles  (2026-10-27)

## Corpus Check
- Corpus is ~23,250 words - fits in a single context window. You may not need a graph.

## Summary
- 335 nodes · 445 edges · 39 communities (23 shown, 16 thin omitted)
- Extraction: 94% EXTRACTED · 6% INFERRED · 0% AMBIGUOUS · INFERRED: 28 edges (avg confidence: 0.88)
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- Community 0
- Community 1
- Community 2
- Community 3
- Community 4
- Community 5
- Community 6
- Community 7
- Community 9
- Community 10
- Community 11
- Community 12
- Community 13
- Community 14
- Community 15
- Community 16
- Community 17
- Community 18
- Community 19
- Community 20
- Community 21
- Community 24
- Community 25
- Community 26
- Community 27
- Community 31
- Community 32
- Community 33
- Community 34
- Community 38

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
- `graphify (graphifyy via mise)` --references--> `mise`  [EXTRACTED]
  llm/README.md → CLAUDE.md
- `Delegation through pstack` --references--> `pstack plugin (cursor/plugins)`  [EXTRACTED]
  CLAUDE.md → llm/README.md
- `CLAUDE.md (project instructions)` --references--> `llm/pstack-priority.md`  [EXTRACTED]
  CLAUDE.md → llm/README.md
- `grill-me skill` --semantically_similar_to--> `grill-with-docs skill`  [INFERRED] [semantically similar]
  llm/skills/grill-me/SKILL.md → llm/skills/grill-with-docs/SKILL.md

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **Design renewal and scoring loop** — llm_skills_design_renewal_skill_design_renewal, llm_skills_design_renewal_skill_reference_round, llm_skills_design_renewal_skill_adjustment_round, llm_skills_design_score_loop_skill_design_score_loop, llm_skills_design_score_loop_skill_awwwards_sheet [EXTRACTED 1.00]
- **grill-with-docs decision record and glossary formats** — llm_skills_grill_with_docs_skill_grill_with_docs, llm_skills_grill_with_docs_adr_format_adr_format, llm_skills_grill_with_docs_poc_format_poc_format, llm_skills_grill_with_docs_context_format_context_format [EXTRACTED 1.00]
- **Terminal stack: herdr on Ghostty** — claude_herdr, claude_ghostty, claude_ghostty_config, claude_herdr_config_toml, claude_kitty_protocols [EXTRACTED 1.00]
- **Opt-in setups kept out of make all** — readme_make_personal, readme_make_home_server, claude_personal_marker, readme_make_targets [INFERRED 0.85]
- **yomiyasu rewrite references** — llm_skills_yomiyasu_skill_yomiyasu, llm_skills_yomiyasu_references_gemini_syntax_gemini_syntax, llm_skills_yomiyasu_references_slop_catalog_slop_catalog, llm_skills_yomiyasu_references_domains_tech_tech_domain, llm_skills_yomiyasu_references_domains_business_business_domain, llm_skills_yomiyasu_references_domains_essay_essay_domain [INFERRED 0.85]

## Communities (39 total, 16 thin omitted)

### Community 0 - "Community 0"
Cohesion: 0.06
Nodes (38): No preamble, no recap, no closing pleasantries, Business/spec domain spec, Boundary conditions and responsible subject, Restoring embodiment and personal subject, Essay domain spec, No grandiosity of experience, Bold/bullet inflation limits (bullets <=15%), Restoring procedures and specifics (+30 more)

### Community 1 - "Community 1"
Cohesion: 0.10
Nodes (14): generate(), herdr(), locked(), main(), owned(), read_state(), write_state(), add_defaults() (+6 more)

### Community 2 - "Community 2"
Cohesion: 0.07
Nodes (29): mise, llm/AGENTS.md, Codex configuration setup, llm/codex.toml, Dropped skills (review-pr, guide, empirical-prompt-tuning, find-skills, autopilot, asuforce-mode, create-pr, apply-review, create-repo), graphify (graphifyy via mise), graphify hook-guard PreToolUse hooks, Herdr integration and tab titles (+21 more)

### Community 3 - "Community 3"
Cohesion: 0.09
Nodes (21): Brewfile, CLAUDE.md (project instructions), config/packages/linux.txt, Makefile, omarchy (Arch Linux) target, Symlink-based dotfiles architecture, config/home-server/, make home-server (+13 more)

### Community 4 - "Community 4"
Cohesion: 0.13
Nodes (12): grill-me skill, ADR Format, Sequential ADR numbering in docs/adr, What qualifies as an ADR, CONTEXT.md Format, Single vs multi-context repos, Cleanup pass (promote to ADR, absorb into CONTEXT.md, delete), PoC Decision Log Format (+4 more)

### Community 5 - "Community 5"
Cohesion: 0.13
Nodes (16): Ghostty, config/ghostty/config.ghostty, Hammerspoon Option+Space hotkey, herdr (terminal multiplexer), config/herdr/config.toml, kitty keyboard and graphics protocols, autoharness plugin, env plugin (+8 more)

### Community 6 - "Community 6"
Cohesion: 0.29
Nodes (4): HookTest, generate(), generate(), generate()

### Community 7 - "Community 7"
Cohesion: 0.25
Nodes (6): analyze_markdown_metrics(), check_sentence_end_repetitions(), extract_plain_sentences(), get_frontmatter_line_count(), lint_text(), main()

### Community 9 - "Community 9"
Cohesion: 0.22
Nodes (10): Adjustment round, DESIGN.md, design-renewal skill, Reference round, Short commands (preview, commit, advisor review, polish), Awwwards scoring sheet, design-score-loop skill, impeccable commands (+2 more)

### Community 10 - "Community 10"
Cohesion: 0.28
Nodes (8): CONFIG_HOME, HYPR_BINDINGS, HYPR_MARKER, install_system(), link_user(), home-server.sh script, SRC, USER_NAME

### Community 11 - "Community 11"
Cohesion: 0.43
Nodes (5): adopt_config(), CONFIG_HOME, link_config(), OS, link.sh script

### Community 12 - "Community 12"
Cohesion: 0.33
Nodes (5): i-have-adhd skill, Lead with the next action, Persistence until stop adhd mode, Pre-send check, Restate state every turn

### Community 13 - "Community 13"
Cohesion: 0.53
Nodes (4): equalize_columns(), is_worktree(), repo_name_of(), herdr-repo-workspace.sh script

### Community 14 - "Community 14"
Cohesion: 0.33
Nodes (5): Codex coding delegation under pstack, Codex model and effort by task, Verify delegated Codex work, Claude plugin installation, pstack routing and priority

### Community 15 - "Community 15"
Cohesion: 0.50
Nodes (3): Closing headings Blocked on me / Changed / Found, Global agent instructions (llm/AGENTS.md), ~/.claude/pstack-models.md import

### Community 16 - "Community 16"
Cohesion: 0.70
Nodes (4): claude_proc(), keep_reason(), process_session(), restart.sh script

### Community 17 - "Community 17"
Cohesion: 0.40
Nodes (4): autoharness reflector, claude-restart skill, herdr pane, restart.sh script

### Community 18 - "Community 18"
Cohesion: 0.50
Nodes (4): clawd.png (Clawd pixel-art icon), Claude brand orange #D97757, Go-to-bed notification icon, Clawd mascot (Claude Code pixel-art character)

### Community 19 - "Community 19"
Cohesion: 0.50
Nodes (3): bindings, $docs, $schema

### Community 20 - "Community 20"
Cohesion: 0.50
Nodes (3): Focused HTML visual file, show-me skill, Text visuals (pseudocode, call tree, file tree, Mermaid, diff)

### Community 21 - "Community 21"
Cohesion: 0.50
Nodes (3): BREW, GH, brew.sh script

### Community 24 - "Community 24"
Cohesion: 0.67
Nodes (3): HackGen font (fetched by scripts/pkg.sh), omarchy pkg add, Linux package list (Brewfile counterpart)

### Community 25 - "Community 25"
Cohesion: 0.67
Nodes (3): Graphify usage rules, Shared graphify artifacts, Graphify installation and hooks

## Knowledge Gaps
- **79 isolated node(s):** `CONFIG_HOME`, `HYPR_BINDINGS`, `HYPR_MARKER`, `SRC`, `USER_NAME` (+74 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 143 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **16 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `yomiyasu skill` connect `Community 0` to `Community 7`?**
  _High betweenness centrality (0.083) - this node is a cross-community bridge._
- **Are the 4 inferred relationships involving `yomiyasu skill` (e.g. with `Business/spec domain spec` and `Essay domain spec`) actually correct?**
  _`yomiyasu skill` has 4 INFERRED edges - model-reasoned connections that need verification._
- **What connects `CONFIG_HOME`, `HYPR_BINDINGS`, `HYPR_MARKER` to the rest of the system?**
  _79 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Community 0` be split into smaller, more focused modules?**
  _Cohesion score 0.06387921022067364 - nodes in this community are weakly interconnected._
- **Why does `HookTest` connect `Community 6` to `Community 1`?**
  _High betweenness centrality (0.034) - this node is a cross-community bridge._
- **Should `Community 1` be split into smaller, more focused modules?**
  _Cohesion score 0.09986504723346828 - nodes in this community are weakly interconnected._
- **Should `Community 2` be split into smaller, more focused modules?**
  _Cohesion score 0.0659536541889483 - nodes in this community are weakly interconnected._