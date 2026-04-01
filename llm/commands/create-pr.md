---
allowed-tools: Bash(gh:*), Bash(git:*), Read(.github/*)
description: "Push a Pull Request Draft (PR Number Optional)"
---

以下の手順で新しいPull request(PR)を作成してください。

1. Jira チケット ID の取得
2. 直前コミットの内容確認
3. 手本PRの内容確認
4. 新規PRの作成
5. 新規PRのブラウザ確認

# Jira チケット ID の取得

以下のコマンドを使用して、現在のブランチ名から Jira チケット ID を取得します。

```bash
git branch --show-current | cut -d'/' -f1
```

# 直前コミットの内容確認

以下のコマンドを使用して、現在のブランチにおける直前のコミットの内容を確認します。

```bash
git show HEAD
```

# 手本PRの内容確認

以下のコマンドを使用して、手本PRの内容を確認します。`ARGUMENT`にはPRの番号を入力します。

```bash
gh pr view $ARGUMENT
```

もし`ARGUMENT`が空の場合は、このステップはスキップしてください。

# PRテンプレートファイルの内容確認

`.github/PULL_REQUEST_TEMPLATE.md`または`${HOME}/dotfiles/.github/PULL_REQUEST_TEMPLATE.md`が存在する場合のみファイルを読み取り、PRテンプレートファイルの内容を確認します。

もし両方のファイルが存在しない場合は、このステップはスキップしてください。

# 新規PRの作成

直前コミット、手本PR、PRテンプレートファイルの内容を元に、以下のコマンドを使用して新規PRを作成します。

```bash
gh pr create --draft --assignee @me --base main --title "[<取得した Jira チケット ID>] <直前コミット/手本PRを参考にPRタイトルを作成してください>" --body "<直前コミット/手本PR/PRテンプレートファイルを参考にPR内容を作成してください>"
```

## 新規PRのブラウザ確認

以下のコマンドを使用して、作成した新規PRをブラウザで開きます。

```bash
gh pr view --web
```
