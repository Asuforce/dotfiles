---
name: create-pr
description: 現在のブランチのコミット履歴全体を把握し、Jira チケット ID・PRテンプレート・手本PRを参照してドラフトPRを作成する。ユーザーが「PRを作って」「プルリク作成して」と依頼したときに使う。引数としてPR番号を受け取った場合はその番号のPRを手本として参照する。
---

# create-pr

ブランチ全体のコミット履歴を把握した上で、Jira チケット ID・PRテンプレート・手本PRを参照してドラフトPRを作成する。

## Phase 1: コンテキスト収集

### Jira チケット ID の取得

ブランチ名の最初のセグメント（`/` 区切り）を Jira チケット ID として使用する。

```bash
git branch --show-current | cut -d'/' -f1
```

取得できない場合やブランチ名に `/` が含まれない場合は、Jira チケット ID なしで進める。

### デフォルトブランチの特定

```bash
git symbolic-ref refs/remotes/origin/HEAD | sed 's|refs/remotes/origin/||'
```

取得できない場合は `main` にフォールバックする。取得した値を以降の手順で `$DEFAULT_BRANCH` として使用する。

### ブランチ全体のコミット履歴と差分の取得

`$DEFAULT_BRANCH` との差分を取得してPRの変更内容を把握する。

```bash
# コミット一覧
git log $DEFAULT_BRANCH...HEAD --oneline

# コード変更全体
git diff $DEFAULT_BRANCH...HEAD
```

## Phase 2: テンプレート・手本の確認

### PRテンプレートの読み込み

以下の優先順で探し、最初に見つかったファイルを読み込む。どちらも存在しない場合はスキップする。

1. `.github/PULL_REQUEST_TEMPLATE.md`
2. `${HOME}/dotfiles/.github/PULL_REQUEST_TEMPLATE.md`

### 手本PRの確認（引数指定時のみ）

引数としてPR番号が指定されている場合のみ実行する。

```bash
gh pr view $ARGUMENT
```

## Phase 3: PR作成

### リモートへの push

ブランチが origin に push されていない場合は、`gh pr create` の前に push する。

```bash
git push -u origin $(git branch --show-current)
```

既に push 済みの場合はスキップしてよい。

### PR の作成

収集したコンテキストを元にドラフトPRを作成する。

```bash
gh pr create \
  --draft \
  --assignee @me \
  --base $DEFAULT_BRANCH \
  --title "[<Jira チケット ID>] <変更内容を端的に表すタイトル>" \
  --body "$(cat <<'EOF'
<PRテンプレートに沿った本文。テンプレートがない場合は変更内容・背景・テスト計画を簡潔に記述>
EOF
)"
```

タイトルの作成基準:
- Jira チケット ID が取得できた場合: `[PROJ-123] 変更内容を端的に表すタイトル`
- 取得できなかった場合: `変更内容を端的に表すタイトル`
- コミット群全体を俯瞰した変更の目的を1文で表現する
- 実装の詳細ではなく「何を達成するか」を書く
- 言語はリポジトリのコミットメッセージの慣習に合わせる

本文の作成基準:
- PRテンプレートがある場合はその見出し構造をそのまま使い、各節にコミット履歴・差分から読み取った内容を記述する
- テンプレートがない場合は「変更内容 / 背景 / テスト方法」の3節を基本構成とする
- 影響範囲・確認手順など必要に応じて節を追加してよい
- 手本PRがある場合はそのトーン・構成を参考にする

## Phase 4: ブラウザ確認

作成したPRをブラウザで開く。

```bash
gh pr view --web
```
