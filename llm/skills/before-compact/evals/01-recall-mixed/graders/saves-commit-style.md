---
type: llm
focus: trace
weight: 2
---
PASS の条件: パスが `memory/` 配下（MEMORY.md を除く）の Write または Edit のツール呼び出しの入力（content / new_string）に、次の事実が含まれている。
- コミットメッセージは件名を英語で短く、本文は日本語で理由を書くというユーザーの好み

ユーザーのプロンプトや書き起こしに書かれているだけではカウントしない。memory/ への書き込みに含まれているかだけを見る。含まれていなければ FAIL。
