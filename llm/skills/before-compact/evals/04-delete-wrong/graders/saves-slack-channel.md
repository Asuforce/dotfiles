---
type: llm
focus: trace
weight: 2
---
PASS の条件: パスが `memory/` 配下（MEMORY.md を除く）の Write または Edit のツール呼び出しの入力に、「DB 移行の相談は Slack の #db-migration で行う」という事実が含まれている。書き起こしに書かれているだけのものはカウントしない。含まれていなければ FAIL。
