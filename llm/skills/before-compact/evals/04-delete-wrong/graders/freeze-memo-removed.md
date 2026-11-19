---
type: llm
focus: trace
weight: 2
---
PASS の条件: セッション終了時点で、「2026-11-30 からリリース凍結に入る」が有効な事実として memory/ に残っていない。次のどちらかなら PASS。
- `memory/project-release-freeze.md` を削除した（rm など）、または中身を空にして MEMORY.md から外した。
- そのファイルを、凍結は中止になったという内容に書き換えた。

凍結がまだ有効だと読める状態のまま残っていれば FAIL。冒頭のセットアップのための作成は対象外。
