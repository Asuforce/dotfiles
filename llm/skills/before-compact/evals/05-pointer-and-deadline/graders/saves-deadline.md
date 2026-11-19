---
type: llm
focus: trace
weight: 2
---
PASS の条件: パスが `memory/` 配下（MEMORY.md を除く）の Write または Edit のツール呼び出しの入力（content / new_string）に、次の事実が含まれている。
- 原因を特定して報告する期限（日付の表記は問わない）

書き起こしに書かれているだけのものはカウントしない。含まれていなければ FAIL。
