---
name: pr-review
description: Use this skill when the user asks to "review PR comments", "PRのレビュー", "レビューコメントに対応", "review comments", "address PR feedback", or wants to respond to pull request review comments. Fetches latest comments via gh command and scopes response to only those comments.
version: 1.0.0
---

# PR Review Response

`gh` コマンドでPRのレビューコメントを取得し、スコープを絞って対応するスキル。

## 手順

### 1. PR番号の特定

カレントブランチから自動取得を試みる:

```bash
gh pr view --json number,title,url 2>/dev/null
```

取得できない場合はユーザーに確認する。

### 2. レビューコメントの取得

```bash
gh pr view <PR番号> --json reviews,comments --jq '.reviews[] | {author: .author.login, state: .state, body: .body, submittedAt: .submittedAt}'
```

```bash
gh pr review-comments <PR番号> 2>/dev/null || gh api repos/:owner/:repo/pulls/<PR番号>/comments --jq '.[] | {path: .path, line: .line, body: .body, user: .user.login, created_at: .created_at}'
```

### 3. 対応コメントの絞り込み

- デフォルト: **最新レビューのコメントのみ**対応
- ユーザーが件数を指定した場合はそれに従う
- 対応済みのコメント（resolved）は除外する

**対応するコメント一覧をユーザーに提示し、確認を得てから作業を開始する。**

### 4. スコープ確認

```bash
git diff origin/<base-branch>...HEAD --name-only
```

レビューコメントが指摘しているファイルと、PRで変更済みのファイルを照合する。
**PRのスコープ外ファイルへの変更は行わない。**

### 5. 対応実施

各コメントに対して:
1. 指摘内容を理解して修正方針を提示
2. 承認を得てから編集
3. 修正後に該当コメントへの返答文を提案

## 原則

- GitHub API は `gh` コマンドのみ使用（GitHub MCP は使わない）
- 最新のレビューコメントのみを対象とし、過去のコメントを掘り返さない
- PRのスコープを超えた変更は行わない
