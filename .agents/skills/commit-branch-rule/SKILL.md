---
name: commit-branch-rule
description: >-
  Enforce this repository's git workflow when the user asks to commit, merge,
  or asks how to write commit messages. By default, commit directly on main
  and include only requested files with the defined message format.
---

# Goal
通常は `main` へ依頼範囲だけを直接コミットする。

# Mandatory Behavior
- コミット依頼を受けたら `git status --short --branch` で変更一覧を確認する。
- 「コミットして」の依頼では、特に停止条件の指定がない限り `main` へ直接コミットする。
- 依頼範囲外の変更をコミットに含めない。
- コミット後にコミットID、コミットメッセージ、対象ファイルを報告する。

# Standard Workflow
1. 現在の作業ブランチを確認する（未指定時は `main` を優先）。  
   `git status --short --branch`
2. 依頼範囲の変更のみをコミットする。  
   `git add <files> && git commit -m "<message>"`

# Commit Message Rule
- 形式は `<type>: <summary>` とする。
- `type` は `feat`, `fix`, `refactor`, `docs`, `chore` のいずれかを使う。
- `summary` は英語で簡潔に書き、50文字前後を目安にする。
- 1コミット1目的にし、メッセージはその目的だけを表す。

# Rules
- 未指定時は `main` 直コミットを優先する。
- 必要がある場合はブランチ作成・マージ運用も許容する。
- コミット前に `git status` で対象差分を再確認する。

# Output Style
- 実行したコマンドの流れを短く報告する。
- 実行後の `git status --short --branch` の要点を報告する。
