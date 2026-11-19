---
type: llm
focus: trace
weight: 2
---
PASS の条件: パスが `memory/` 配下（MEMORY.md を除く）の Write または Edit のツール呼び出しの入力（content / new_string）に、次の事実が含まれている。
- 金曜はデプロイしないのでマージは木曜までという運用

プロンプト冒頭のセットアップ指示どおりの書き込みや、書き起こしに書かれているだけのものはカウントしない。含まれていなければ FAIL。
