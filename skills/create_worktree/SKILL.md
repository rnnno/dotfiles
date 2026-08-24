---
name: create_worktree
description: Use this skill whenever the user asks to create a git worktree, "ワークツリーを作成", "worktree作って", "新しい作業用にworktree", "別ブランチを隔離して作業", or wants an isolated workspace for a new task. This is the user's preferred worktree method — it places the worktree in a SIBLING directory (../<repo名>-<作業内容>), NOT under .claude/worktrees/, and supersedes the default placement and the native EnterWorktree tool. Trigger even when the location is not stated explicitly.
version: 1.0.0
---

# create_worktree

ワークツリーをリポジトリと同じ階層のサブフォルダ `../<repo名>-<作業内容>` に作るスキル。
（`.claude/worktrees/` 配下には作らない。）

**冒頭で宣言する**: 「create_worktree スキルでワークツリーを作成します」

## 重要な前提

- ネイティブの `EnterWorktree` ツールは必ず `.claude/worktrees/` 配下に作るため **使わない**。
  配置場所を制御するため `git worktree add` を直接使う。
- 「リポジトリルート」は今いるディレクトリではなく **メインの作業ツリー** を指す
  （既にワークツリー内にいる場合があるため、必ず特定し直す）。
- このスキルはユーザーの明示的な希望であり、既定の `.claude/worktrees/` 配置や
  `using-git-worktrees` スキルの既定より優先する。

## 手順

### 1. メインリポジトリルートとリポジトリ名を特定

```bash
REPO_ROOT=$(git worktree list --porcelain | awk '/^worktree /{print $2; exit}')
REPO_NAME=$(basename "$REPO_ROOT")
PARENT=$(dirname "$REPO_ROOT")
```

`git worktree list` の最初のエントリが常にメイン作業ツリー。今いる場所がワークツリー内でも
これでメインルートを正しく取れる。

### 2. 作業内容スラッグを決める（会話文脈から自動命名）

これから行う作業を表す短い kebab-case スラッグを付ける
（例: 「DDB userinfo に初期データを入れるスクリプト」→ `userinfo-seed-script`）。

- ユーザーが明示的に名前を指定していればそれを優先する。
- 文脈から判断できなければ、推測したスラッグを一言添えて確認してから進める。
- 2〜4 語程度、英小文字・数字・ハイフンのみ。

配置先とブランチ名:

```bash
SLUG="userinfo-seed-script"          # 上で決めた値
DEST="$PARENT/$REPO_NAME-$SLUG"
BRANCH="$SLUG"                        # 原則スラッグと同名。ユーザー希望のプレフィックスがあれば従う
```

配置先 `DEST` が既に存在する場合は上書きせず、別スラッグを提案するか確認する。
`BRANCH` が既存なら `-b` を外して既存ブランチを使うか、別名にするか確認する。

### 3. ベースブランチを毎回ユーザーに確認する

候補を組み立ててから `AskUserQuestion` で選んでもらう（毎回確認する）。

```bash
# リポジトリのデフォルトブランチ（origin/HEAD）
DEFAULT_BRANCH=$(git symbolic-ref --quiet refs/remotes/origin/HEAD 2>/dev/null | sed 's#^refs/remotes/origin/##')
# 取れなければ origin/main → origin/master の順で存在確認してフォールバック
# develop-vn の有無
git rev-parse --verify --quiet origin/develop-vn >/dev/null && echo "develop-vn あり"
```

提示する選択肢:

- **デフォルトブランチ（推奨）** — `origin/<DEFAULT_BRANCH>` の最新から分岐。
- **develop-vn** — `origin/develop-vn` が存在する場合のみ候補に追加。
- **現在の HEAD** — 今のブランチ状態を引き継いで分岐。
- ユーザーが他のブランチを指定すればそれに従う。

選ばれた ref を `BASE_REF`（`origin/<branch>` 形式）とする。最新化したい場合は分岐前に
`git fetch origin <branch>` してよい。

### 4. ワークツリーを作成

```bash
git worktree add "$DEST" -b "$BRANCH" "$BASE_REF"
```

作成後は以降の作業を `DEST`（絶対パス）で行う。シェルは `cd "$DEST"` し、
ファイル操作も `DEST` 配下の絶対パスを使う。ハーネス上のセッション cwd は移動しないため、
ユーザーには「エディタ／新しいターミナルでこのフォルダを開くと作業しやすい」と案内する。

### 5. セットアップ（依存インストールのみ）

パッケージマネージャをロックファイルで検出してインストールする。**テストは実行しない。**

```bash
cd "$DEST"
if [ -f package.json ]; then
  if   [ -f pnpm-lock.yaml ]; then pnpm install
  elif [ -f yarn.lock ];      then yarn install
  else                             npm install
  fi
fi
# Node 以外のエコシステムがあれば同様に検出（Cargo.toml→cargo build / go.mod→go mod download 等）。
# 該当が無ければスキップ。
```

### 6. 完了報告

実際のコマンド出力で確認してから報告する:

```bash
git -C "$DEST" rev-parse HEAD
git -C "$DEST" rev-parse "$BASE_REF"   # 上の HEAD と一致することを確認
git -C "$DEST" status --short
```

報告内容:

- 作成パス（`DEST`）
- ブランチ名とベース（`BASE_REF` と一致する commit を確認済みと明記）
- 依存インストール結果
- 以降の作業ディレクトリ（`DEST` 絶対パス）の案内
