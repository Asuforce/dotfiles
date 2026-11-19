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
- [リリース凍結](project-release-freeze.md) — 2026-11-30 から凍結
```

`memory/project-release-freeze.md`:
```
---
name: project-release-freeze
description: 年末のリリース凍結
metadata:
  type: project
---
2026-11-30 からリリース凍結に入る。それ以降のマージは禁止。
```

このセッションの会話の書き起こしは以下のとおり。リポジトリはこの sandbox には無い。

<transcript>
user: 11/30 からのリリース凍結、あれ中止になった。今年は凍結なし。
assistant: 承知しました。では 12 月もマージして問題ないですね。
user: そう。あと DB 移行の相談は Slack の #db-migration チャンネルでやることになった。
</transcript>
