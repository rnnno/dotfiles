---
name: delete_worktree
description: Use this skill whenever the user asks to delete or clean up a git worktree — "worktreeを削除", "worktree消して", "ワークツリーを片付けて", "この作業ツリーはもう不要", "delete worktree", "remove worktree" — or when a PR has been merged and its local worktree is no longer needed. Trigger even when the target worktree is not stated explicitly (e.g. "ここもう終わったから消して" while inside a worktree).
version: 1.0.0
---

# delete_worktree

worktree を PR の状態に応じて安全に削除するスキル。リモートブランチには一切触れない。

**冒頭で宣言する**: 「delete_worktree スキルで worktree を安全に削除します」

## 重要な前提

- メイン作業ツリー（`git worktree list` の先頭）は絶対に削除しない。
- リモートブランチは削除しない（ローカルのみ扱う）。
- 対象の特定: 今いるディレクトリが linked worktree ならそれを対象とする。そうでなければ `git worktree list` を提示し、AskUserQuestion で選んでもらう。

## 手順

### 1. 対象 worktree とブランチを特定

```bash
# 今いる場所が対象リポジトリ外なら git -C <リポジトリ内の任意のパス> を付ける
git worktree list --porcelain
MAIN_ROOT=$(git worktree list --porcelain | awk '/^worktree /{print $2; exit}')
WT_PATH=<対象 worktree の絶対パス>
BRANCH=$(git -C "$WT_PATH" branch --show-current)
```

- `WT_PATH` が `MAIN_ROOT` と同じなら中断（メインは削除不可）。
- detached HEAD（`BRANCH` が空）の場合はブランチ処理をスキップし、worktree 削除のみ扱う。

### 2. 未コミット変更の確認

```bash
git -C "$WT_PATH" status --porcelain   # 空でなければ未コミットあり（未追跡含む）
```

未コミット変更があれば AskUserQuestion で選択してもらう:

- **stash して続行** — `git -C "$WT_PATH" stash push -u -m "delete_worktree: $BRANCH"`（stash はリポジトリ全体に残るためブランチ削除後も復元可）
- **破棄して続行** — worktree 削除時に `--force` を使う
- **中断** — 何もせず状況を報告して終了

### 3. PR の状態を確認して動作を決める

```bash
(cd "$MAIN_ROOT" && gh pr view "$BRANCH" --json state,isDraft,url,title)
```

| PR の状態 | 動作 |
|---|---|
| MERGED | worktree 削除 + ローカルブランチ削除 |
| CLOSED（未マージ） | worktree 削除。ブランチは未マージコミットを提示し、確認が取れた場合のみ削除 |
| OPEN / DRAFT | **何も削除せず中断**。PR の URL と状態を報告して終了 |
| PR なし | worktree 削除。ブランチは保持 |
| PR 状態が確認不能 | **何も削除せず中断**。失敗理由を報告して終了 |

gh コマンド失敗時は理由で区別する（「失敗 = PR なし」と即断しない）:

- `no pull requests found` / `no git remotes found` → **PR なし** として扱う
- それ以外（未認証・ネットワーク断・レートリミット等） → **確認不能**。OPEN の PR を見落とす可能性があるため中断する

- OPEN / DRAFT で中断した後、ユーザーが明示的に削除を指示した場合のみ、ブランチを保持して worktree だけ削除してよい。
- CLOSED の確認では、消える内容を先に提示する:

```bash
DEFAULT_BRANCH=$(git symbolic-ref --quiet refs/remotes/origin/HEAD 2>/dev/null | sed 's#^refs/remotes/origin/##')
git log --oneline "origin/${DEFAULT_BRANCH}..${BRANCH}"   # 未マージコミット一覧
```

### 4. 削除の実行

セッションの cwd が `WT_PATH` 配下なら先に `MAIN_ROOT` へ移動する。

```bash
cd "$MAIN_ROOT"
git worktree remove "$WT_PATH"          # 手順2で「破棄」を選んだ場合のみ --force を付ける
```

ブランチ削除（MERGED、または CLOSED で確認済みの場合のみ）:

```bash
git branch -d "$BRANCH"
```

- MERGED なのに `-d` が失敗する場合は、マージ後の追加コミットが残っているということ。
  `git log --oneline` で内容を提示し、確認が取れた場合のみ `-D` を使う。
- CLOSED（未マージ）は手順3で確認済みであることを前提に `-D` を使う。

### 5. 完了報告

実際の出力で確認してから報告する:

```bash
git worktree list                # WT_PATH が消えていること
git branch --list "$BRANCH"      # 期待どおり（削除済み or 保持）であること
ls "$WT_PATH"                    # No such file or directory であること
```

報告内容:

- 削除した worktree パス
- PR の状態と URL（PR なしの場合はその旨）
- ブランチの扱い（削除 / 保持）と理由
- stash した場合は stash 名と復元方法（`git stash list` で確認可）
