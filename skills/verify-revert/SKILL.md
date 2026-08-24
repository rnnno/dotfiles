---
name: verify-revert
description: Use this skill when the user asks to "verify revert", "revertを確認", "差分がゼロか確認", "verify diff against develop", "revertが完了したか確認", or wants to confirm that a revert or cleanup is fully reflected against a target branch.
version: 1.0.0
---

# Verify Revert

revert や差分クリーンアップが完全に反映されているかをターゲットブランチと照合して検証するスキル。

## 手順

### 1. origin を最新化

```bash
git fetch origin
```

ローカルブランチが古い状態で差分を見ると誤判断するため、**必ず最初に fetch する**。

### 2. ターゲットブランチの特定

ユーザーが指定していない場合は以下の順で推定する:
1. カレントブランチの upstream: `git rev-parse --abbrev-ref @{upstream} 2>/dev/null`
2. `origin/develop` が存在するか確認
3. `origin/main` または `origin/master`

### 3. ローカルとoriginの乖離確認

```bash
git rev-list HEAD..origin/<target> --count
git rev-list origin/<target>..HEAD --count
```

ローカルが origin より大幅に遅れている場合（例: 100コミット以上）は警告する。

### 4. 差分確認

```bash
git diff origin/<target-branch>
```

差分がある場合:
- 差分ファイル一覧と内容を提示
- **「完了」とは言わない** — 差分がゼロになるまで修正を続ける

差分がない場合:
- 「`origin/<target>` との差分はゼロです。revert が完全に反映されています。」と報告する

### 5. 予期しない差分への対処

差分が残っている場合:
1. 意図した差分か意図しない差分かをユーザーに確認
2. 意図しない差分であれば修正方針を提案
3. 修正後に手順4を再実行して再検証

## 原則

- `git fetch` なしに差分を信頼しない
- 差分がゼロになるまで「完了」と報告しない
- ローカルブランチが origin から大幅に遅れている場合は必ず警告する
