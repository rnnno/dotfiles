# AGENTS.md

## Repository Overview

- このリポジトリは個人用の dotfiles 管理リポジトリ。
- 主に各種ツール設定、環境セットアップ用スクリプト、辞書や補助ファイルを管理する。

## File Structure

- `config/`: 各アプリケーションの設定ファイル群
- `pictures/`: 壁紙などの画像アセット
- `skk-user-dict/`: SKK ユーザー辞書
- `install.sh`: 初期セットアップ用スクリプト
- `link.sh`: 設定ファイルのリンク作成スクリプト

## Language

- 指定がない限り日本語で回答する。

## Branch Policy

- 運用ブランチは `main` とする。
- 変更は必ず `main` から作業ブランチを作成して行う。
- `main` へ直接コミットしない。

## Branch Start

1. `git checkout main`
2. `git pull --ff-only origin main`
3. `git checkout -b task/<topic>`

## Commit And Merge

1. 作業ブランチで変更をコミットする
2. `git checkout main`
3. `git merge --no-ff task/<topic>`
4. `git push origin main`

## Commit Message Rule

- 形式は `<type>: <summary>` とする。
- `type` は `feat`, `fix`, `refactor`, `docs`, `chore` のいずれかを使う。
- `summary` は英語で簡潔に書き、50文字前後を目安にする。
- 1コミット1目的にする。

## Safety Checks

- マージ前に `git status --short --branch` を確認する。
- 競合が出た場合は作業ブランチで解消してから再マージする。
