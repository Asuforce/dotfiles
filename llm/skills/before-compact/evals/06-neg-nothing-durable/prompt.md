---
max_turns: 20
timeout_seconds: 300
allowed_tools: [Read, Glob, Grep, Write, Edit, Skill]
runs: 3
---
/before-compact

メモのディレクトリは `./memory/` とする（MEMORY.md もここに置く）。このセッションの会話の書き起こしは以下のとおり。リポジトリはこの sandbox には無い。

<transcript>
user: `src/utils/date.ts` の formatDate をリファクタして。
assistant: 引数を Date | string に広げ、内部で正規化するようにしました。
user: テスト足して。
assistant: `src/utils/date.test.ts` に 4 ケース追加しました。全部通っています。
user: コミットして。
assistant: commit 9f3e2a1 でコミットしました。
</transcript>
