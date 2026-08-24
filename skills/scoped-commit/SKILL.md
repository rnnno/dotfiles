---
name: scoped-commit
description: Use this skill when the user asks to "commit", "git commit", "コミット", "変更をコミット", or wants to commit code changes. Enforces scope confirmation, lint/format/typecheck and unit tests before committing. Prevents batching unrelated changes into a single commit.
version: 1.0.0
---

# Scoped Commit

コミット前にスコープ確認・lint/format/typecheck・ユニットテストを行い、単一の論理的変更として確実にコミットするスキル。

## 手順

### 1. スコープ確認

```bash
git diff --stat
git diff --cached --stat
```

変更されているファイル一覧をユーザーに提示し、**このコミットに含めるファイルを確認する**。
複数の論理的変更が混在している場合は分割を提案すること。

### 2. ステージング確認

```bash
git diff --cached
```

ステージ済みの内容を確認し、意図しない変更が含まれていないかチェックする。
未ステージのファイルがある場合は「含めるか」をユーザーに確認する。

### 3. lint / format / typecheck

プロジェクトのツールを自動検出して実行する:

- `package.json` に `lint` スクリプトがあれば: `npm run lint`
- `package.json` に `format` スクリプトがあれば: `npm run format`
- TypeScript プロジェクト (`tsconfig.json` が存在): `npm run typecheck` または `npx tsc --noEmit`
- `biome.json` が存在: `npx biome check .`
- `.eslintrc*` が存在: `npx eslint .`
- `Makefile` に `lint` ターゲットがあれば: `make lint`

エラーがあればコミット前に修正する。

### 4. テスト（ユニット）

`package.json` に `test` スクリプトがあれば、関連するユニットテストを実行して通ることを確認する:

- 既定: `CI=true npm test`（watch 暴走を防ぐため `CI=true` を付与）
- 失敗する状態ではコミットしない。修正してから再実行する。
- E2E（Playwright 等、ビルドや外部依存が必要な重いスイート）はここでは走らせない。**PR 作成前**に別途実行する。

### 5. コミットメッセージ確認

変更内容を要約した簡潔なコミットメッセージ案を提示し、ユーザーの承認を得てからコミットする。

### 6. コミット実行

```bash
git commit -m "<確認済みメッセージ>"
```

## 原則

- 1コミット = 1つの論理的変更
- バッチ作業は事前にユーザーへ確認
- lint/format/typecheck エラーやユニットテスト失敗がある状態でコミットしない
- `--no-verify` は使わない
