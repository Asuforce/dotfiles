---
type: llm
focus: {source: file, path: memory/MEMORY.md}
---
PASS の条件（すべて満たす）:
- memory/ に作られたメモファイルごとに、そのファイルへリンクする行が 1 行ずつある。
- 各行は 1 行のポインタ（タイトル、ファイル名、短い説明）。短い説明に要点が入るのはよい。事実の本文を複数行にわたって書いていない。
- frontmatter がない。
