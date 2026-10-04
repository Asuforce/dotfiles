---
name: autopilot
description: Drive a task from requirements to a merged PR autonomously. Grill the plan up front with grill-with-docs, then run commands and browser work without asking, consult advisor() when unsure, review the PR with advisor, and merge it. Use when the user says "autopilot", "自律で進めて", "マージまで任せる", or hands over a task to finish unattended.
disable-model-invocation: true
---

# autopilot

最初の grill でユーザーと合意を取り、その後はマージまで止まらずに進める。ユーザーの回答を待つのは Phase 1 と「止まる条件」のときだけ。

## Phase 0: 前提

```bash
test "${HERDR_ENV:-}" = 1 && echo herdr-ok
gh auth status
gh repo view --json owner --jq .owner.login
```

オーナーが `Asuforce` 以外のリポジトリでは、マージまで進めない。Phase 4 の draft PR までで止めて報告する。

herdr が使えなければ並列化せず、このセッションで直列に進める。`gh` が未認証なら対話ログインが必要なので、そこで止まって `! gh auth login` を案内する。

## Phase 1: Grill

`grill-with-docs` を実行し、収束するまで質問を続ける。コードを読めば分かる事実は質問せず自分で調べる。

収束したら、次の3つを CONTEXT.md か ADR、なければ作業ディレクトリのタスクメモに書く。

- 終了条件。テスト、スクリーンショット、コマンド出力など、実行して確かめられる述語で書く。
- 作業単位の分割。各単位は検証できる状態で終わる大きさにする。
- ユーザーが Phase 1 で決めた制約と、決めなかったもの(後者は既定値を置いて報告に載せる)。

終了条件が1文で書ける小さな作業(typo、1ファイルの変更など)では、質問を0〜1回にとどめる。

ユーザーが収束を確認したら、この時点を自律実行の承認とみなす。以降 `AskUserQuestion` で実行許可を取らない。

## Phase 2: 判断の順序

迷ったら上から順に当てはめる。

1. 動かして確かめられる事実は動かして確かめる。テスト、再現、ブラウザ操作、`--help`、ログ。
2. 確証がないとき、方針を変えるとき、同じエラーが2回続いたときは `advisor()` を呼ぶ。助言と手元の証拠が食い違うときは、食い違いを示してもう一度 `advisor()` を呼ぶ。
3. 次の「止まる条件」に当たるときだけ、ユーザーに聞く。

止まる条件:

- force push、main/master への直接 push、`gh pr merge --admin` など保護の回避
- 本番デプロイ、データ削除、人への外部メッセージ送信
- 対話が必須の認証、権限の追加
- 実験で決められない好みや製品方針で、Phase 1 の既定値が使えないもの
- 同じ原因の修正を3回試しても終了条件に近づかない行き詰まり
- `advisor()` の呼び出しが1タスクで5回前後に達しても、方針が定まらないとき

止まるときは、herdr の通知と `PushNotification` で知らせてから報告を書く。

分類器にコマンドを拒否されたら、迂回せず拒否を1回だけ報告し、`! ` 付きのコマンドを案内する。

## Phase 3: 実行

- 作業は専用ブランチか worktree で行う(`git-worktree-branch-isolation`)。main には書かない。
- 作業単位ごとに実物で検証してから次へ進む。ビルドが通るだけで完了にしない。
- ブラウザ操作は `chrome-devtools` MCP を使う(`llm/mcps/browser.json`)。ツールは遅延ロードなので、`ToolSearch` で `chrome-devtools` を検索してから呼ぶ。動作確認はスナップショットかスクリーンショットを取って自分で見る。
- 独立した作業単位が2つ以上あるときだけ、別エージェントに分ける。それ以外は1セッションで直列に進める。分けるときは `herdr` スキルに従い、herdr のペインで通常の Claude Code として起動する。ペイン内のエージェントは自分の `advisor()` を持つ。渡す指示には Phase 1 の合意、終了条件、このスキルの Phase 2 を含める。
- 数時間かかる作業は組み込みの `/loop` で再開点を作る。

## Phase 4: PR 作成

`visual-pr` スキルで PR を作る。Draft で作られるので、Phase 5 を通過してから `gh pr ready` で外す。

## Phase 5: advisor レビュー

1. `gh pr diff` とテスト結果をこのセッションで実際に表示する。advisor は会話履歴しか見えない。
2. `advisor()` を呼び、指摘を must-fix とそれ以外に分ける。
3. must-fix は直して push し、直した内容が指摘と食い違っていないか再度 `advisor()` に確認する。それ以外は直すか、理由を添えて見送る。
4. 追加で機械的な確認が欲しいときは `code-review` と `security-review` を併用してよい。

PR にレビューコメントが付いたら `apply-review` で対応する。

## Phase 6: CI とマージ

```bash
gh pr ready
gh pr checks --watch --fail-fast
```

CI が失敗したらログを読み、原因を直して push する。3回直しても通らなければ止まる条件に当たる。

次をすべて満たしたときだけマージする。

- 終了条件を、実行結果で確認済み
- CI が green
- Phase 5 の must-fix がすべて解消済み
- マージ可能で、保護の回避が不要

```bash
gh pr merge --squash --delete-branch
gh pr view --json state,mergedAt
```

`state` が `MERGED` であることを自分で確認する。承認が必要で merge が拒否された場合は `--admin` を使わず、状況を報告して止まる。マージ後は worktree とローカルブランチを片付ける。

## Phase 7: 報告

日本語で書き、最後を次の3見出しで終える。

- `Blocked on me`: ユーザーにしか進められないこと。なければ「なし」。
- `Changed`: マージした PR のリンクと、変更の要点。
- `Found`: 作業中に分かったこと、Phase 1 の既定値で決めたこと、advisor に見送った指摘とその理由。
