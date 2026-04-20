---
name: apply-review
description: 現在のブランチに紐づくPRのレビューコメントを収集・分類し、must-fix を優先して修正を適用、コミット・プッシュまで自律的に完了する。ユーザーが「レビュー対応して」「レビューコメントを反映して」と依頼したとき、またはPR上に未対応コメントが存在すると判断したときに使う。
---

# apply-review

PRのレビューコメントを収集・分類し、優先度に従って修正を適用してコミット・プッシュまで完了する。

## Phase 1: PR状況の把握

現在のブランチに紐づくPRの基本情報と変更範囲を確認する。

```bash
gh pr view
gh pr diff
```

PRが存在しない場合は「対応するPRが見つかりません」と報告して終了する。

## Phase 2: レビューコメントの収集と分類

コード外コメントとコード内コメントを両方取得する。

```bash
# コード外レビューコメント
gh pr view --comments

# コード内レビューコメント
gh api "repos/{owner}/{repo}/pulls/$(gh pr view --json number --jq '.number')/comments"
```

取得したコメントを以下の3種に分類する。分類は自律的に判断する。

| 分類 | 内容 | 対応 |
|---|---|---|
| `[must-fix]` | バグ指摘・問題指摘・要求された変更 | 必ず修正する |
| `[suggestion]` | コードスタイル・設計の提案 | 修正する（明らかに不合理な提案を除く） |
| `[skip]` | 質問のみ・賞賛・情報提供 | 修正不要 |

`[must-fix]` が0件かつ `[suggestion]` が0件の場合は「対応すべきレビューコメントはありません」と報告して終了する。

## Phase 3: 修正の適用

`[must-fix]` を先に処理し、次に `[suggestion]` を処理する。各コメントが指摘するファイルを Read してから Edit で修正する。複数ファイルへの修正は並列で実施する。

修正を適用する際の判断基準:
- コメントの意図を正確に読み取り、指摘箇所だけでなく同種の問題が他にあれば合わせて修正する
- 矛盾するコメントがある場合はユーザーに確認する
- テストファイルが存在する場合、修正内容と整合するか確認する

## Phase 4: 修正内容の確認とコミット・プッシュ

修正したファイルの一覧と各変更の概要をユーザーに提示し、問題がなければコミット・プッシュする。

```bash
# 修正内容の確認
git diff

# コミット（レビュー対応内容を1行で表現）
git add <修正したファイル>
git commit -m "$(cat <<'EOF'
<レビュー対応内容を簡潔に1行で記述>
EOF
)"

# プッシュ
git push
```

コミットメッセージの例:
- `Fix null pointer dereference in user auth handler`
- `Rename variable for clarity per review`
- `Apply review: fix error handling and rename vars`

コミット・プッシュ後、PRのURLを表示して完了を報告する。

```bash
gh pr view --web
```
