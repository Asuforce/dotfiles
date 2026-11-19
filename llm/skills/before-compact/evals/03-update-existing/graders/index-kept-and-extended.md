---
type: llm
focus: {source: file, path: memory/MEMORY.md}
---
PASS の条件（すべて満たす）:
- pref-review-style.md へのリンク行がちょうど 1 行ある（重複していない）。
- 新しく作ったメモファイルごとにリンク行が 1 行ある。
- 各行は 1 行のポインタ（タイトル、ファイル名、短い説明）。短い説明に要点が入るのはよい。複数行にわたる本文や frontmatter が無ければ PASS。
