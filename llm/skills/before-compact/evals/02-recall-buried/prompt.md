---
max_turns: 20
timeout_seconds: 300
allowed_tools: [Read, Glob, Grep, Write, Edit, Skill]
runs: 3
---
/before-compact

メモのディレクトリは `./memory/` とする（MEMORY.md もここに置く）。このセッションの会話の書き起こしは以下のとおり。リポジトリはこの sandbox には無い。

<transcript>
user: キャッシュ層の v2 を作りたい。
assistant: 既存のキャッシュ実装を見せてください。キャッシュは高速化のための仕組みで、一般にメモリ上にデータを保持し...
user: 説明は短くていい。
user: `src/cache/index.ts` にある。
assistant: 読みました。LRU ですね。
user: そう。容量は 1000 件。
assistant: TTL はありますか。
user: ない。v2 で入れたい。
assistant: TTL のデフォルト値の案はありますか。
user: 5 分で。
assistant: 依存を追加するときのパッケージマネージャは何を使いますか。
user: pnpm で。
assistant: 了解です。lru-cache を入れますか。
user: 自前でいい。
assistant: では Map ベースで書きます。
user: テストは vitest。
assistant: 既存のテストファイルはありますか。
user: `src/cache/index.test.ts`。
assistant: 読みました。
user: 設計の背景は https://docs.example.internal/design/cache-v2 にまとめてある。読んでおいて。
assistant: 読みます。
user: TTL の判定は取得時でいい。
assistant: 期限切れのエントリはいつ消しますか。
user: 取得時に消す。バックグラウンド掃除はいらない。
assistant: 実装しました。変更点は以下のとおりです。1. Map ベースの LRU に TTL を追加 2. 取得時に期限判定 3. 期限切れは取得時に削除 4. テストを 6 件追加 5. 型定義を整理 ...
user: 長い。要点 2 行で。
assistant: TTL 付き LRU を実装し、テストを追加しました。
user: ちなみに v2 のリリースは 12/7 の週を予定してる。
user: あ、さっきの訂正。パッケージマネージャは pnpm じゃなくて bun。このリポジトリに限らず今後ずっと bun で。
assistant: 承知しました。bun で入れ直します。
user: テスト通った？
assistant: 通りました。
user: 長時間走るジョブは平日 9:30〜10:00 は避けて。その時間は standup で端末を見てないから。
assistant: 承知しました。
user: OK。PR 出しといて。
assistant: 出しました。
user: ありがとう。
</transcript>
