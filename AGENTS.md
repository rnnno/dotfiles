# AGENTS.md

## Repository Overview

- このリポジトリは個人用の dotfiles 管理リポジトリ。
- 主に各種ツール設定、環境セットアップ用スクリプト、辞書や補助ファイルを管理する。

## File Structure

- `config/`: 各アプリケーションの設定ファイル群
- `skills/`: エージェントスキルの実体
- `pictures/`: 壁紙などの画像アセット
- `skk-user-dict/`: SKK ユーザー辞書
- `install.sh`: 初期セットアップ用スクリプト
- `link.sh`: 設定ファイルのリンク作成スクリプト

## Language

- 指定がない限り日本語で回答する。

## Agent Skills

- スキルの実体は `skills/<name>/SKILL.md` の1箇所のみ。ハーネスごとに書き分けない。
- `~/.claude/skills` と `~/.agents/skills` に直接ファイルを作らない。ここは `link.sh` が張る symlink の置き場。
- ディレクトリ名は frontmatter の `name` と一致させる。ディレクトリ名がスキル名になる。
- 配布は `cd ~/dotfiles && ./link.sh`。
- 外部リポジトリから取り込んだスキルは、出所・commit・取得日・改変の有無・ライセンスを `skills/CREDITS.md` に記録する。
- 外部ツールが自分でインストールしたスキル（`~/dotfiles` の外を指す symlink）は管理対象外。
- 手順の詳細は `skills/add-skill/SKILL.md` に従う。

## Branch Policy

- `main` に直接コミットする。

## Commit Message Rule

- 形式は `<type>: <summary>` とする。
- `type` は `feat`, `fix`, `refactor`, `docs`, `chore` のいずれかを使う。
- `summary` は英語で簡潔に書き、50文字前後を目安にする。
- 1コミット1目的にする。

## Safety Checks

- コミット前に `git status --short --branch` で対象差分を確認する。
