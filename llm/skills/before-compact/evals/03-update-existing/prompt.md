---
max_turns: 20
timeout_seconds: 300
allowed_tools: [Read, Glob, Grep, Write, Edit, Skill]
runs: 3
---
/before-compact

メモのディレクトリは `./memory/` とする（MEMORY.md もここに置く）。手順に入る前に、`./memory/` に次の 2 ファイルをこの内容のまま作成すること（前のセッションまでの記憶を再現するため）。

`memory/MEMORY.md`:
```
- [PR レビューの書き方](pref-review-style.md) — レビューコメントは日本語
```

`memory/pref-review-style.md`:
```
---
name: pref-review-style
description: PR レビューコメントの書き方
metadata:
  type: feedback
---
PR レビューのコメントは日本語で書く。
```

このセッションの会話の書き起こしは以下のとおり。リポジトリはこの sandbox には無い。

<transcript>
user: この PR をレビューして。
assistant: レビューしました。コメントを 3 件付けます。
user: レビューコメントには、先頭に重要度を [must] / [should] / [nit] で付けて。今後のレビューも全部そうして。
assistant: 承知しました。
user: あと金曜はデプロイしない運用だから、マージは木曜までに。
assistant: 承知しました。
user: アプリのログは https://logs.example.internal/app で見られる。
</transcript>
