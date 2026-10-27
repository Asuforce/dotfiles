# llm/

Claude Code and Codex configuration for this repository, installed by `scripts/llm.sh`. See the root `CLAUDE.md` for the pointers into this directory; this file carries the reasoning behind them.

## Skills only, no commands

Reusable agent instructions live in `llm/skills/<name>/SKILL.md` only — there is no `llm/commands/` and no `~/.claude/commands` link. Slash commands and skills overlap in what they can express, but a skill carries a `description` that lets the model reach for it unprompted, so keeping both meant maintaining two mechanisms for one job.

`apply-review`, `create-pr`, and `create-repo` moved over from commands and have since been dropped. `create-pr` gave way to pstack's `opening-a-pr`; `apply-review` and `create-repo` went unused in four weeks of session logs, since `code-review` and a plain request to `gh repo create` cover the same ground. Everything else was dropped once Claude Code shipped a built-in that already covered it — the standing test for whether a skill still belongs here:

- `review-pr` — the built-in `code-review` skill takes a PR number and can post or apply its findings.
- `guide` — plan mode explores read-only and presents options for approval, with the `Plan` and `feature-dev:code-architect` agents for the same job in a subagent.
- `empirical-prompt-tuning` — `claude plugin eval` runs eval cases with LLM graders, repeated runs, and a no-plugin ablation arm, and resolves a `~/.claude/skills/<name>` directory as a target.
- `find-skills` — `/plugin` and `claude plugin install` discover and install skills without the separate `npx skills` ecosystem it assumed.
- `autopilot`, then `asuforce-mode` — a hand-rolled copy of pstack's autonomous run (grill, then work through to merge on personal repos only), replaced by the pstack plugin's `poteto-mode` itself.

Current roster, each with no built-in or plugin equivalent:

- `before-compact` saves durable memory before `/compact`.
- `claude-restart` restarts herdr panes still running an outdated Claude Code and resumes each session.
- `design-renewal` and `design-score-loop` redesign a site from references and refine it until it passes an Awwwards-style score.
- `grill-me` and `grill-with-docs` interview the user about a plan; the latter also updates `CONTEXT.md`, ADRs and PoC decision logs.
- `show-me`, `yomiyasu` and `i-have-adhd` are vendored; see [Vendored skills](#vendored-skills).

Add new instructions as `llm/skills/<name>/SKILL.md`, and use `disable-model-invocation: true` for the side-effecting ones instead of reintroducing a command.

`scripts/llm.sh` links each skill into `~/.claude/skills/` individually rather than linking the directory, so a skill added under `llm/skills/` appears only after `make llm`, and one removed or renamed leaves a dangling link to delete by hand.

## Codex

`make llm` は `scripts/codex.sh` も実行する。Codex だけを設定するときは `bash scripts/codex.sh` を使う。Codex 本体のインストールは既存のパッケージ管理に任せ、Python 3.11 以降で設定を読み書きする。`CODEX_HOME` 未指定時の配置は次のとおり。

```text
llm/AGENTS.md ───────────────▶ ~/.claude/CLAUDE.md
             └──────────────▶ ~/.codex/AGENTS.md
llm/skills/<name>/ ──────────▶ 両方の skills/<name>/
npx impeccable install ─────▶ ~/.agents/skills/impeccable/（Codex 用）
llm/codex.toml ──未設定項目を追加─▶ ~/.codex/config.toml
llm/mcps/default.json ──変換───▶ config.toml の MCP
llm/mcps/{coding,browser,infra}.json
                     └─変換──▶ ~/.codex/<用途>.config.toml
```

| Claude Code の設定・機能 | Codex での対応 |
|---|---|
| 日本語、文体、終了時の表記、自作スキル | 共通ファイルをリンク |
| Sonnet、推論 medium | 既存の Codex モデルを維持し、未設定の推論量を medium にする |
| permissions.defaultMode = auto | on-request と auto_review。権限外の操作を自動レビューに回す |
| ローカル編集、ビルド、依存取得 | workspace-write とネットワーク許可 |
| 各リポジトリの CLAUDE.md | AGENTS.md がない階層でのフォールバックとして読む |
| モデル、作業先、ブランチ、コンテキスト、利用枠 | Codex 標準ステータス行と通知 |
| MCP 定義 | stdio/URL、引数、環境変数、無効化状態を TOML に変換 |

用途別 MCP は `codex --profile coding`、`codex --profile browser`、`codex --profile infra` で選ぶ。通常起動でも Context7 と Plannotator Inbox（`plannotator inbox mcp`、CLI が PATH にあること）を読み込み、各プロファイルはベース設定へ MCP を追加する。サーバー実行時には `npx` または `uvx` とネットワークが必要。

設定追加時は既存の値、コメント、フックの信頼情報、プロジェクト設定を維持する。既存の同名 MCP サーバーは丸ごと優先する。変更前のファイルは初回だけ `<ファイル名>.pre-dotfiles.bak` に保存する。再実行は未設定項目の補充なので、以後の設定変更はローカルファイルで行う。カスタム権限プロファイルが設定済みなら、従来の sandbox 設定は追加しない。

Claude の自然言語による `autoMode.allow` / `soft_deny` と Codex の自動レビューは判定方式が異なる。個別のマージ・デプロイ許可や Linux の `make` 許可ルールはコピーしない。管理ポリシーや起動オプションがユーザー設定より優先するため、起動後の `/status` で有効な権限を確認できる。

Impeccable は上流の CLI で Codex 用スキルを `~/.agents/skills/impeccable/` に導入する。`scripts/codex.sh` は導入済みならスキップし、`npx` がなければメッセージを出してスキップする。更新は `npx impeccable update --scope=global --no-hooks --yes`。Codex を再起動し、`/skills` または `$impeccable` で呼び出す。

自動チェックのフックはプロジェクトごとに導入する。そのプロジェクトで `npx impeccable install --providers=codex --scope=project --yes` を実行し、Codex の `/hooks` で承認する。dotfiles のセットアップではプロジェクトのフックを追加しない。[上流の導入手順](https://github.com/pbakaus/impeccable#installation)を参照。

ほかのプラグインは自動移植しない。AutoHarness、pstack、env、mission-control、LSP などには別途 Codex 対応の確認が必要。token-weather のキャッシュ表示も標準ステータス行では再現しない。既存の herdr フックは保持し、タブ名には下記の Codex 専用フックを追加する。`AGENTS.md` の `@~/.claude/pstack-models.md` は Codex では自動展開されず、Claude のモデル別名も移植しない。

設定形式と自動レビューは [OpenAI の設定リファレンス](https://learn.chatgpt.com/docs/config-file/config-reference)、用途別ファイルは [プロファイルの仕様](https://learn.chatgpt.com/docs/config-file/config-advanced) に従う。Codex CLI 0.164.0 で検証。

## Vendored skills

`llm/upstream-skills.tsv` records the upstream commit each vendored skill has been reviewed through. `scripts/llm.sh` prints a compare URL when upstream has moved past that commit; it applies nothing, because these are prompts that have to be read before they're taken. It fails open on a missing `gh`, an unreachable network, or a missing manifest.


### `show-me` (from `humanlayer/skills`)

Turns the current topic into the smallest visual that makes the point: pseudocode, a call or file tree, Mermaid, a `diff`, or a focused HTML file. `llm/AGENTS.md` sends PR descriptions and design documents through it unprompted, so the model has to be able to reach for it on its own.

Upstream's `Make show-me user-invocable` commit adds `disable-model-invocation: true`, which would stop exactly that. The local copy leaves the flag off, and the manifest is pinned past that commit so the next upstream review starts after it.

### `yomiyasu` (from `nanaism/yomiyasu`)

Rewrites AI-generated Japanese prose into natural Japanese: it restores the subject-verb-object structure AI output tends to drop, replaces figurative verbs (`壊れる`, `効く`, `溶かす`) with literal ones, and strips emoji, trailing colons, and excess bold/bullets. No built-in covers this — `code-review` and `writing-for-agents` govern structure and correctness, not Japanese prose register.

Upstream ships the skill twice: once at the repo root (for `npx skills add`) and once under `skills/yomiyasu/` (for its Claude Code plugin marketplace). The two are identical; the local copy is vendored from `skills/yomiyasu/` since that is the self-contained directory. Dropped: `.claude-plugin/` (plugin manifests, meaningless outside the marketplace flow) and `assets/algo-artis.png` (a logo image the skill itself never reads).

Upstream's `SKILL.md` warns against running it alongside other Japanese style/proofreading skills, since the instructions can conflict; disable one of them if that happens.


### `i-have-adhd` (from `ayghri/i-have-adhd`)

Shapes responses for a reader with ADHD: next action first, numbered steps, one concrete closing step, no preamble or closers. Invoked with `/i-have-adhd` and stays on until "stop adhd mode". No built-in covers this; the Concise output style only shortens, it does not reorder around the next action.

It ships `disable-model-invocation: true` upstream and keeps it here, so it is opt-in per session. It overlaps the Concise output style and conflicts with the global rule that every turn ends with `Blocked on me` / `Changed` / `Found`; the skill's own "a rule fights the harness" clause lets the harness win.

Upstream's `agents/` (`openai.yaml`, `gemini.toml`) was dropped as other-vendor exports.

## Plugins

`llm/plugins.tsv` lists the plugins `scripts/llm.sh` installs, one `<marketplace source>\t<plugin id>[\t<OS>]` per line, so a new machine gets the same set from `make llm`. The script refreshes every marketplace, adds each missing one and installs each missing plugin at scope `user` (`claude plugin marketplace list --json` / `claude plugin list --json`), and runs `claude plugin update` on the plugins already there. A failed refresh or update prints a line and the run continues. A source of `-` marks a plugin Claude Code ships itself, which is enabled through `enabledPlugins` instead and checked there, since `claude plugin list` does not show it. A third column holding a `uname -s` name (`Linux`) limits the row to that OS; other systems print a skip line.

```
llm/plugins.tsv
├─ tigerless-labs/autoharness   autoharness@autoharness
├─ hamzafer/claude-code-mods    token-weather, mission-control, usage-meter
├─ davekiss/mods                env@davekiss
├─ -                            cc-plugin-you-should-know@builtin
├─ cursor/plugins               pstack@cursor-plugins
├─ pbakaus/impeccable           impeccable@impeccable
├─ openai/codex-plugin-cc       codex@openai-codex
└─ backnotprop/plannotator      plannotator@plannotator

llm/pstack-priority.md ──link──▶ ~/.claude/rules/pstack-priority.md
llm/pstack-codex.md ────link──▶ ~/.claude/rules/pstack-codex.md
```

They are plugin-installed rather than vendored like the skills above, because each ships hooks, an MCP server or a backend that a skill-only copy under `llm/skills/` would not run. None carries local changes, so none has an entry in `llm/upstream-skills.tsv`. A version bump takes `make llm`, then a restart. `cloudflare@cloudflare` is installed by hand on this machine and is not in the list.

- `autoharness` self-learns skills from session work into `.claude/skills/` and prunes them by usage rate. It ships a Python backend, an MCP server (`stage_skill`) and `SessionStart`/`Stop`/`PreToolUse`/`SessionEnd` hooks.
- `token-weather` draws the context fill and a prompt-cache countdown above the prompt. Session transcripts here reach 500k to 880k tokens and often sit idle for over five minutes, which is where both readouts pay off.
- `usage-meter` shows the 5-hour and 7-day plan usage.
- `mission-control` opens `/mission`, a live tree of agents and tool calls. Its code-map view needs macOS and Chrome, so only the agent view applies on Linux. It makes one small model call per change to summarise it.
- `env` has Claude ask for a value in a pane it cannot read, so tokens for Cloudflare and Terraform never enter the transcript.
- `cc-plugin-you-should-know` runs a side agent that flags what the user or Claude may have missed.
- `pstack` is Cursor's own plugin, from `cursor/plugins`: `poteto-mode` routes work to playbooks and skills. The package ships no hooks, so nothing starts it by itself; it runs when invoked or when the autoharness skill `pstack-poteto-mode-routing` matches the task. pstack's skills defer to `CLAUDE.md` on conflicts. This setup wants the reverse, so `llm/pstack-priority.md` is linked into `~/.claude/rules/` and names the three points where pstack's rule replaces `CLAUDE.md`'s: the closing headings, PR and commit text, and whether to ask. It is not under `llm/skills/`, so it is not linked as a skill. Model choices per role live in the untracked `~/.claude/pstack-models.md`, which `llm/AGENTS.md` imports. That file can only name Claude models, so `llm/pstack-codex.md` is linked next to the priority rules to route the coding roles to `codex:codex-rescue` (from `openai/codex-plugin-cc`) and to pin Codex's model and effort per task class for cost: `gpt-6.1-sol` at `low` by default (perf work included), `gpt-6-luna` for mechanical edits, `high` only after a run fails verification.
- `impeccable` is a single skill, `/impeccable <command>`, with 24 design commands (`critique`, `audit`, `polish`, `distill`, and so on) for improving a web UI, plus a detector of 61 AI-design tells. It ships `SessionStart`/`PostToolUse`/`Stop` hooks that check UI files after edits; they act per project, switched by `/impeccable hooks on|off`. Run `/impeccable init` once in a project to write `PRODUCT.md`.
- `plannotator` adds the `plannotator_inbox` tool, through which Claude leaves messages and questions in the Plannotator Inbox (`plannotator inbox` opens it) for the user to answer later without blocking the session, plus plan review and annotate hooks. It calls the `plannotator` CLI, which the upstream installer puts in `~/.local/bin` and this repo does not install.

## graphify

graphify はコードベースを知識グラフにする CLI と `/graphify` スキルの組。プラグインではなく PyPI パッケージ `graphifyy`（y が2つ）として配布されるため、`plugins.tsv` ではなく mise で入れる。スキルはパッケージからのコピーなので、`scripts/runtime.sh` を実行するたびに入れ直して CLI の更新に追従させる。

```text
scripts/runtime.sh
  mise use -g uv, pypi:graphifyy
  CLAUDE_CONFIG_DIR=<一時> graphify install
    <一時>/skills/graphify ──移動──▶ ~/.claude/skills/graphify
    <一時>/CLAUDE.md                  # 捨てる
  graphify install --platform codex ─▶ ~/.codex/skills/graphify（codex があるときだけ）
  jq で ~/.claude/settings.json の PreToolUse に追加（未登録のときだけ）
    Bash|Grep ─▶ graphify hook-guard search
    Read|Glob ─▶ graphify hook-guard read
```

ユーザースコープの `graphify install` は `~/.claude/CLAUDE.md` に登録ブロックを追記する。この環境ではそれが `llm/AGENTS.md` へのリンクなので、一時ディレクトリに書かせてスキルだけを取り出す。Claude Code はフロントマターからスキルを見つけるため、ブロックがなくても `/graphify` は動く。`make all` は llm を runtime より先に実行するので、この処理は `llm.sh` ではなく `runtime.sh` に置いている。

Codex は並列抽出に `[features] multi_agent = true` を要するため、`llm/codex.toml` に入れている。

検索や読み取りの前にグラフ参照を促す PreToolUse フックは、`graphify claude install` ならプロジェクトの `.claude/settings.json` に入るが、ここではユーザー設定に入れる。ガードはカレントディレクトリに `graphify-out/graph.json` があるときだけ指示を出すので、グラフのないリポジトリでは何も起きない。コマンドは絶対パスではなく `graphify` と書き、mise の shim を通してバージョン更新後も動くようにしている。グラフ参照の常時指示は `llm/AGENTS.md` の `# graphify` 節に書いてある。git フックは入れない。

このリポジトリのグラフは `graphify-out/` にコミットし、別のマシンでもビルドせずに使えるようにしている。コミットするのはグラフ本体、レポート、HTML、manifest、cost.json と意味抽出のキャッシュ（`cache/semantic/`）で、ほかのキャッシュと一時ファイルは `graphify-out/.gitignore` で除外している。意味キャッシュを共有するので、別のマシンの `--update` は変わったドキュメントだけを LLM で抽出し直す。`.gitattributes` は `graph.json` に graphify の merge driver を指定しているが、driver は `graphify hook install` でしか登録されないので、未登録のマシンでは通常の 3-way マージになる。

## herdr integration

`scripts/llm.sh` regenerates `llm/skills/herdr/SKILL.md` from `herdr --skill` on every run (git-ignored, so herdr upgrades do not show up as diffs) and installs herdr's Claude Code integration hook plus the repository-owned `herdr-repo-workspace.sh` hook, which keeps herdr at "one repository = one workspace = side-by-side worktrees" (adapted from https://zenn.dev/gemcook/articles/herdr-worktree-parallel).

`herdr-tab-title.sh` runs on `Stop` and copies the `ai-title` Claude Code writes into the transcript onto the herdr tab label (24 characters at most). It only replaces a label herdr numbered itself (`1`, `2`, ...) or the title it set earlier from the same pane, so a tab renamed by hand, or claimed by another pane's session, keeps its name. On `/clear` (`SessionStart`) it puts the herdr-assigned number back on a tab still carrying the title it set, and the next session's first `Stop` names it afresh.

Codex では `scripts/codex.sh` が `codex-herdr-tab-title.py` をリンクし、既存の `hooks.json` に次の処理を追加する。再実行しても重複登録しない。設定後は Codex を起動し直し、対話操作の `/hooks` で追加した3つのフックを確認・信頼する必要がある。

```text
UserPromptSubmit → ユーザー発言を保存
Stop（バックグラウンド）
  → 直近6発言と前回のタイトルを codex exec で要約
  → 24文字以内の日本語タイトルで herdr のタブ名を更新
SessionStart（startup / clear / fork）→ 自分が付けた名前だけ番号に戻す
```

各発言は先頭4,000文字まで、状態は `~/.local/state/codex-herdr-tab-title/`（`XDG_STATE_HOME` 対応）に保存する。会話全体の transcript は解析しない。要約には既存の Codex 認証を使い、応答ごとに追加のモデル利用が発生する。モデルの既定値は `gpt-6-luna` で、Codex 起動前の環境変数 `HERDR_TITLE_MODEL` で変更できる。要約用プロセスはユーザー設定を読み込まないため、独自のモデルプロバイダー設定は引き継がない。

要約用の Codex は一時ディレクトリで起動し、hook・プラグイン・MCP・シェルツールを引き継がない。生成が35秒以内に完了しなければタブ名を維持する。手動で付けた名前や別ペインが付けた名前も維持し、生成中に次のターンや新規セッションが始まった場合は古い結果を破棄する。バックグラウンド実行なので通常の応答完了を待たせないが、Codex 終了時に生成中の処理はキャンセルされる。

## Status line

`llm/statusline.sh` is the Claude Code status line (model, repository, branch). The context bar, rate limits and cost it used to carry moved to the `token-weather` and `usage-meter` mods, which draw them above the prompt. `scripts/llm.sh` symlinks it to `~/.claude/statusline.sh` and adds the `statusLine` entry to `settings.json` only when none exists, so a machine that configured its own keeps it.

`llm/permissions-allow.json` lists the Bash rules (`make link` and the other `make` targets) that `scripts/llm.sh` unions into `permissions.allow` in `settings.json`. The merge runs on Linux only. Existing entries on a machine are kept.
