---
name: commit-branch-rule
description: >-
  Enforce this repository's git workflow when the user asks to create a branch,
  commit, merge, or push (for example: ブランチ切って, コミットして, pushして,
  マージして), or asks how to write commit messages. Start from main, work on
  task/<topic>, commit only requested files with the defined message format,
  merge back into main, and push.
---

# Goal
`main` から作業ブランチを切り、依頼範囲だけをコミットし、`main` へマージして push する。

# Mandatory Behavior
- コミット依頼を受けたら `git status --short --branch` で変更一覧を確認する。
- 依頼範囲外の変更をコミットに含めない。
- コミット後にコミットID、コミットメッセージ、対象ファイルを報告する。

# Standard Workflow
1. `main` を最新化する。  
   `git checkout main && git pull --ff-only origin main`
2. `main` から作業ブランチを作成する。  
   `git checkout -b task/<topic>`
3. 作業ブランチで変更をコミットする。  
   `git add <files> && git commit -m "<message>"`
4. 作業ブランチを `main` にマージして push する。  
   `git checkout main && git merge --no-ff task/<topic> && git push origin main`

# Commit Message Rule
- 形式は `<type>: <summary>` とする。
- `type` は `feat`, `fix`, `refactor`, `docs`, `chore` のいずれかを使う。
- `summary` は英語で簡潔に書き、50文字前後を目安にする。
- 1コミット1目的にし、メッセージはその目的だけを表す。

# Rules
- `main` へ直接コミットしない。
- マージ前に `git status` がクリーンであることを確認する。
- 競合がある場合は作業ブランチで解消してからマージする。

# Output Style
- 実行したコマンドの流れを短く報告する。
- 実行後の `git status --short --branch` の要点を報告する。
