---
name: cherry-pick-scope
description: Use this skill when the user asks to "cherry-pick", "cherry pick commits", "cherry-pickする", "コミットを持ってくる", or wants to apply specific commits from another branch. Verifies scope before picking to prevent including out-of-scope changes.
version: 1.0.0
---

# Cherry-Pick Scope Check

cherry-pick 前にスコープ外のコミットが含まれていないかを確認してから実行するスキル。

## 手順

### 1. 対象コミットの確認

ユーザーが指定したコミットハッシュまたはブランチについて内容を表示する:

```bash
git show --stat <commit-hash>
# または複数の場合
git log --oneline <source-branch> ^<target-branch>
```

各コミットが変更するファイル一覧をユーザーに提示する。

### 2. スコープ外ファイルのチェック

現在のPR/タスクスコープと照合する:

```bash
git diff origin/<base-branch>...HEAD --name-only
```

cherry-pick 対象コミットに含まれるファイルが、**現在のPRスコープ外であれば警告する**。

スコープ外ファイルが含まれる場合の対応:
- そのコミット全体を含めるか確認
- 必要なファイルのみ持ってくる場合は `git checkout <commit> -- <file>` を提案
- スコープ外変更を含む場合はユーザーに明示的な承認を求める

### 3. コンフリクト予測

```bash
git cherry-pick --no-commit <commit-hash>
git diff --cached --stat
git cherry-pick --abort
```

dry-run 的に確認し、コンフリクトが予想されるファイルを事前に提示する。

### 4. cherry-pick 実行

ユーザーの承認後に実行:

```bash
git cherry-pick <commit-hash>
```

コンフリクトが発生した場合は内容を提示し、解決方針をユーザーと確認してから解決する。

### 5. 型チェック・lint

cherry-pick 後にプロジェクトの検証を実行:

```bash
npm run typecheck 2>/dev/null || npx tsc --noEmit 2>/dev/null
npm run lint 2>/dev/null
```

## 原則

- cherry-pick 前に必ずスコープ確認
- スコープ外ファイルを含む場合は明示的な承認を得る
- 複数コミットを一括 cherry-pick する場合は1件ずつ内容を確認する
