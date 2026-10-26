# Graph Report - dotfiles  (2026-10-26)

## Corpus Check
- Corpus is ~24,159 words - fits in a single context window. You may not need a graph.

## Summary
- 300 nodes · 403 edges · 37 communities (20 shown, 17 thin omitted)
- Extraction: 98% EXTRACTED · 2% INFERRED · 0% AMBIGUOUS · INFERRED: 9 edges (avg confidence: 0.82)
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- Codex 設定とタブ命名
- Omarchy 設定所有権
- LLM スキルとプラグイン導入
- 日本語文章と読みやすさ
- タブ命名の競合テスト
- 日本語文章の静的検査
- セットアップと夜間運用
- 移行判断とモデル選択
- 設計対話と意思決定文書
- 参照デザインと評価
- Claude Code 導入処理
- ホームサーバー構成
- Herdr リポジトリ作業領域
- 設定リンクと引き継ぎ
- Claude セッション再起動
- 説明用の可視化
- Linux パッケージ導入
- Claude キーバインド
- 初期ブートストラップ
- Homebrew 導入
- セッション記憶の保存
- mise ランタイム導入
- Herdr タブ命名フック
- Claude ステータス行
- macOS デフォルト設定
- Codex 導入
- Xcode 導入
- Clawd ラスター画像
- Clawd ベクター画像

## God Nodes (most connected - your core abstractions)
1. `HookTest` - 14 edges
2. `main()` - 11 edges
3. `lint_text()` - 8 edges
4. `add_defaults()` - 8 edges
5. `grill-with-docs` - 7 edges
6. `generate()` - 6 edges
7. `analyze_markdown_metrics()` - 6 edges
8. `get_frontmatter_line_count()` - 5 edges
9. `extract_plain_sentences()` - 5 edges
10. `main()` - 5 edges

## Surprising Connections (you probably didn't know these)
- `Asuforce personal repositories` --semantically_similar_to--> `make home server`  [INFERRED] [semantically similar]
  docs/poc/autopilot/2026-10-04-autopilot-scope-and-gates.md → README.md
- `migration scan batch script` --semantically_similar_to--> `codex codex rescue`  [INFERRED] [semantically similar]
  docs/poc/jev-integration/2026-09-28-migration-prefilter.md → llm/pstack-codex.md
- `Codex herdr tab title hooks` --implements--> `herdr`  [EXTRACTED]
  llm/README.md → CLAUDE.md
- `restart stale Claude panes` --references--> `herdr`  [EXTRACTED]
  llm/skills/claude-restart/SKILL.md → CLAUDE.md
- `pstack` --references--> `codex codex rescue`  [EXTRACTED]
  CLAUDE.md → llm/pstack-codex.md

## Import Cycles
- None detected.

## Communities (37 total, 17 thin omitted)

### Community 0 - "Codex 設定とタブ命名"
Cohesion: 0.10
Nodes (14): generate(), herdr(), locked(), main(), owned(), read_state(), write_state(), add_defaults() (+6 more)

### Community 1 - "Omarchy 設定所有権"
Cohesion: 0.08
Nodes (24): config source of truth, ctrl g prefix, fail open hooks, Ghostty, herdr, llm skills, mise, personal marker (+16 more)

### Community 2 - "LLM スキルとプラグイン導入"
Cohesion: 0.11
Nodes (20): pstack, Changed Found Blocked on me, graphify explicit trigger, Japanese response style, show me document visuals, pstack precedence, pstack reply PR commit question overrides, AutoHarness (+12 more)

### Community 3 - "日本語文章と読みやすさ"
Cohesion: 0.09
Nodes (7): i-have-adhd, Business writing rules, Essay writing rules, Technical writing rules, Japanese syntax transformation principles, AI-generated Japanese style catalog, yomiyasu

### Community 4 - "タブ命名の競合テスト"
Cohesion: 0.29
Nodes (4): HookTest, generate(), generate(), generate()

### Community 5 - "日本語文章の静的検査"
Cohesion: 0.25
Nodes (6): analyze_markdown_metrics(), check_sentence_end_repetitions(), extract_plain_sentences(), get_frontmatter_line_count(), lint_text(), main()

### Community 6 - "セットアップと夜間運用"
Cohesion: 0.19
Nodes (14): advisor five call limit, Asuforce personal repositories, autopilot historical PoC, draft PR boundary, grill agreement, herdr and PushNotification, crawler 06 00, Linux pkg link llm runtime (+6 more)

### Community 7 - "移行判断とモデル選択"
Cohesion: 0.21
Nodes (11): Claude Code generation, Jev typed decisions, migration scan batch script, official HTTP integration, TypeSafe key unresolved, worklist json, codex codex rescue, gpt 6 1 sol low coding (+3 more)

### Community 8 - "設計対話と意思決定文書"
Cohesion: 0.19
Nodes (6): grill-me, Architecture Decision Record, CONTEXT.md glossary, CONTEXT-MAP.md, PoC decision log, grill-with-docs

### Community 9 - "参照デザインと評価"
Cohesion: 0.18
Nodes (9): Impeccable, DESIGN md measured estimated chosen, reference driven design renewal, user reference trait selection, all categories at least 7 5, Awwwards scoring loop, design 40 usability 30 creativity 20 content 10, five round stop limit (+1 more)

### Community 10 - "Claude Code 導入処理"
Cohesion: 0.18
Nodes (10): CLAUDE_AGENTS_FILE, CLAUDE_CONFIG_DIR, CLAUDE_SETTINGS_FILE, CLAUDE_SKILLS_DIR, DOTFILES_LLM, KEYBINDINGS_DEST, PLUGINS_MANIFEST, llm.sh script (+2 more)

### Community 12 - "ホームサーバー構成"
Cohesion: 0.28
Nodes (8): CONFIG_HOME, HYPR_BINDINGS, HYPR_MARKER, install_system(), link_user(), home-server.sh script, SRC, USER_NAME

### Community 13 - "Herdr リポジトリ作業領域"
Cohesion: 0.53
Nodes (4): equalize_columns(), is_worktree(), repo_name_of(), herdr-repo-workspace.sh script

### Community 14 - "設定リンクと引き継ぎ"
Cohesion: 0.53
Nodes (5): adopt_config(), CONFIG_HOME, link_config(), OS, link.sh script

### Community 15 - "Claude セッション再起動"
Cohesion: 0.70
Nodes (4): claude_proc(), keep_reason(), process_session(), restart.sh script

### Community 16 - "説明用の可視化"
Cohesion: 0.40
Nodes (4): Diff visualization, Focused HTML artifact, Mermaid interaction diagrams, show-me

### Community 17 - "Linux パッケージ導入"
Cohesion: 0.40
Nodes (4): FONT_DIR, HACKGEN_VERSION, LIST, pkg.sh script

### Community 18 - "Claude キーバインド"
Cohesion: 0.50
Nodes (3): bindings, $docs, $schema

### Community 19 - "初期ブートストラップ"
Cohesion: 0.50
Nodes (3): GITHUB_DIR, REPO_DIR, bootstrap.sh script

### Community 20 - "Homebrew 導入"
Cohesion: 0.50
Nodes (3): BREW, GH, brew.sh script

## Knowledge Gaps
- **74 isolated node(s):** `GITHUB_DIR`, `REPO_DIR`, `BREW`, `GH`, `SRC` (+69 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 141 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **17 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `yomiyasu` connect `日本語文章と読みやすさ` to `日本語文章の静的検査`?**
  _High betweenness centrality (0.043) - this node is a cross-community bridge._
- **What connects `GITHUB_DIR`, `REPO_DIR`, `BREW` to the rest of the system?**
  _74 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Codex 設定とタブ命名` be split into smaller, more focused modules?**
  _Cohesion score 0.09986504723346828 - nodes in this community are weakly interconnected._
- **Why does `HookTest` connect `タブ命名の競合テスト` to `Codex 設定とタブ命名`?**
  _High betweenness centrality (0.033) - this node is a cross-community bridge._
- **Should `Omarchy 設定所有権` be split into smaller, more focused modules?**
  _Cohesion score 0.08465608465608465 - nodes in this community are weakly interconnected._
- **Should `LLM スキルとプラグイン導入` be split into smaller, more focused modules?**
  _Cohesion score 0.1067193675889328 - nodes in this community are weakly interconnected._
- **Should `日本語文章と読みやすさ` be split into smaller, more focused modules?**
  _Cohesion score 0.09090909090909091 - nodes in this community are weakly interconnected._
## 生成上の制約と構造

```text
コード33件 ── AST抽出 ──┐
文書27件・画像2件 ─ 意味抽出 ─┼─ 300ノード / 403関係 ─ 37グループ
                           └─ graph.json / graph.html / GRAPH_REPORT.md
```

- 整合性診断: 未定義の端点を参照する関係76件、自己参照1件、同じ端点への関係の統合4件。グラフの完全性には制約があります。
- Lua 3件はASTでシンボルを検出できませんでした。未分類の設定ファイル32件は自動検出対象外です。
- トークン費用の0は実測値ではありません。エージェントの使用量が取得できず、未計測です。
- `graphify-out/` は作業ツリー内に生成しました。現在はgitの除外対象ではないため、`git status` に表示されます。
- ベンチマークは推定値です。全体約20,000トークン、平均クエリ約3,037トークン、削減倍率6.6倍と出ましたが、ベンチマーク独自のコーパス推定15,000語は検出時の24,159語と一致しません。
