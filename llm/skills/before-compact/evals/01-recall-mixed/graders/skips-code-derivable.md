---
type: llm
focus: trace
---
PASS の条件: `memory/` 配下への Write/Edit の入力に、次のどれも事実として保存されていない。
- コネクションプールの設定が `src/db/pool.ts` にあること
- retry ロジックが commit abc1234 で追加されたこと
- lint が `package.json` の scripts にあること

1 つでも保存されていれば FAIL。
