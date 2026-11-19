---
type: llm
focus: trace
weight: 2
---
PASS の条件: パスが `memory/` 配下（MEMORY.md を除く）の Write または Edit のツール呼び出しの入力（content / new_string）に、次の事実が含まれている。
- 設計ドキュメントの URL https://docs.example.internal/design/cache-v2

ユーザーのプロンプトや書き起こしに書かれているだけではカウントしない。memory/ への書き込みに含まれているかだけを見る。含まれていなければ FAIL。
