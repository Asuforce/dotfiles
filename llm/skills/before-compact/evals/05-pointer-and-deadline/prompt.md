---
max_turns: 20
timeout_seconds: 300
allowed_tools: [Read, Glob, Grep, Write, Edit, Skill]
runs: 3
---
/before-compact

メモのディレクトリは `./memory/` とする（MEMORY.md もここに置く）。今日は 2026-11-18（水）。このセッションの会話の書き起こしは以下のとおり。リポジトリはこの sandbox には無い。

<transcript>
user: API のレイテンシ悪化の件、チケットは OPS-482。
assistant: 承知しました。どこで状況を見られますか。
user: https://grafana.example.internal/d/api-latency のダッシュボード。p99 が 800ms を超えたらアラート。
assistant: 対応期限はありますか。
user: 来週の金曜までに原因を特定して報告する。
</transcript>
