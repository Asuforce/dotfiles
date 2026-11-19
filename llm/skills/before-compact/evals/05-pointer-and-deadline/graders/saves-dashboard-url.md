---
type: llm
focus: trace
weight: 2
---
PASS の条件: パスが `memory/` 配下（MEMORY.md を除く）の Write または Edit のツール呼び出しの入力（content / new_string）に、次の事実が含まれている。
- ダッシュボード URL https://grafana.example.internal/d/api-latency

書き起こしに書かれているだけのものはカウントしない。含まれていなければ FAIL。
