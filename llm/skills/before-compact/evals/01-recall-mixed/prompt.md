---
max_turns: 20
timeout_seconds: 300
allowed_tools: [Read, Glob, Grep, Write, Edit, Skill]
runs: 3
---
/before-compact

メモのディレクトリは `./memory/` とする（MEMORY.md もここに置く）。このセッションの会話の書き起こしは以下のとおり。リポジトリはこの sandbox には無い。

<transcript>
user: staging の Postgres を 16 に上げる作業を進めたい。期限は 2026-12-04。
assistant: 了解しました。現状のコネクション設定を確認します。
user: コネクションプールの設定は `src/db/pool.ts` に書いてある。
assistant: 確認しました。retry はどうなっていますか。
user: retry ロジックは commit abc1234 で追加済み。
user: あと、コミットメッセージは件名を英語で短く、本文は日本語で理由を書いて。今後もずっとそうして。
assistant: 承知しました。テストは毎回全部走らせますか。
user: 最初は全部って言ったけど訂正。E2E はローカルでは走らせないで、CI に任せる。ユニットテストだけでいい。
assistant: lint も走らせますか。
user: lint は `package.json` の scripts にあるから見ればわかるよ。
user: アップグレード中のメトリクスは https://grafana.example.internal/d/pg-upgrade で見てる。
assistant: PR の説明文を下書きしました。🚀 Postgres 16 対応 ✨ ...
user: 絵文字消して。
assistant: 消しました。ロールバック用に、アップグレード前に pg_dump でフルバックアップを取る手順を入れておくのはどうでしょう。
user: それでいい。
assistant: 承知しました。チェックリストも PR に付けます ✅
user: だから絵文字いらないって。
assistant: 失礼しました、外しました。
user: そういえば昨日の雨すごかったね。
assistant: そうですね。
user: あ、staging の DB を触る前は Slack の #infra-staging に一言書くルールだから、作業前に教えて。
assistant: 承知しました。
user: 今日はこのへんで。
</transcript>
