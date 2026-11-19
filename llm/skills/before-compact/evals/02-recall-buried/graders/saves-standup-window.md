---
type: llm
focus: trace
weight: 2
---
PASS の条件: パスが `memory/` 配下（MEMORY.md を除く）の Write または Edit のツール呼び出しの入力（content / new_string）に、次の事実が含まれている。
- 平日 9:30〜10:00 は standup のため長時間ジョブを走らせないというユーザーの好み

ユーザーのプロンプトや書き起こしに書かれているだけではカウントしない。memory/ への書き込みに含まれているかだけを見る。含まれていなければ FAIL。
