---
name: add-skill
description: Use this skill when adding a new agent skill or taking one in from an external repository — "スキルを作って", "スキルを追加", "skill を新規作成", "外部のスキルを取り込みたい", "add a skill", "create a skill", "install this skill". Skills must be created in ~/dotfiles/skills/, never directly in ~/.claude/skills or ~/.agents/skills.
version: 1.0.0
---

# Add Skill

スキルの実体は `~/dotfiles/skills/` に置き、`link.sh` で各ハーネスへ配布する。
ランタイムディレクトリに直接作ると Git 管理外になり、ハーネス間で内容がずれる。

## 手順

### 1. 実体の場所を確定する

新しいスキルは必ず `~/dotfiles/skills/<name>/SKILL.md` に作る。

- `~/.claude/skills/` と `~/.agents/skills/` には**直接作らない**。ここは `link.sh` が張る symlink の置き場である
- ディレクトリ名は frontmatter の `name` と一致させる。ディレクトリ名がスキル名になるため、後から変えると呼び出し名が変わる

### 2-A. 自作する場合

`~/dotfiles/skills/<name>/SKILL.md` を作成する。frontmatter は既存スキルに倣う:

```yaml
---
name: <ディレクトリ名と同じ>
description: <発動条件を含める。日本語と英語の両方のトリガー語を入れる>
version: 1.0.0
---
```

人間だけが呼べるようにしたい場合は `disable-model-invocation: true` を追加する。
判定基準は「モデルが自律的に手を伸ばして有用か」。有用ならフラグを付けない。

### 2-B. 外部リポジトリから取り込む場合

1. 上流から対象ディレクトリを取得し、`~/dotfiles/skills/<name>/` に配置する
2. **依存を確認する。** 他のスキルを呼ぶスキル（本文に「Call the Skill tool with "..."」等がある）は、呼ばれる側も一緒に取り込まないと機能しない
3. `~/dotfiles/skills/CREDITS.md` に追記する。以下をすべて記録する:
   - 対象ディレクトリ名
   - 上流リポジトリの URL
   - 取得した commit SHA
   - 取得日
   - 上流でのパス
   - 改変の有無（改変した場合はその旨を明記する）
   - ライセンス名と全文（未記載のライセンスの場合）
4. ライセンスを確認する。MIT / BSD / Apache-2.0 は著作権表示と許諾表示の保持を求めるため、`CREDITS.md` への全文記載が必要になる

### 3. 配布する

```bash
cd ~/dotfiles && ./link.sh
```

`link.sh` は `~/dotfiles/skills/` 直下のディレクトリを走査し、`~/.claude/skills/<name>` と
`~/.agents/skills/<name>` の両方に symlink を張る。

### 4. 検証する

```bash
for d in ~/.claude/skills ~/.agents/skills; do
  echo "[$d]"; ls -la "$d"
done
```

新しいスキルが両ディレクトリに symlink として存在し、`~/dotfiles/skills/<name>` を指していることを確認する。
ハーネスがスキルとして認識するのは次回セッション開始時なので、この場では symlink の存在までを確認する。

## 原則

- 実体は `~/dotfiles/skills/` の1箇所のみ。ハーネスごとに書き分けない
- ランタイムディレクトリに実体を作らない
- 外部由来のスキルは `CREDITS.md` の記載と実態を常に一致させる。更新したら commit SHA と取得日を書き換える
- 外部ツールが自分でインストールしたスキル（`~/dotfiles` の外を指す symlink）は取り込まない。ツール側が管理する
