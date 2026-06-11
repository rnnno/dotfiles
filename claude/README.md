# Claude Code config

Claude Code (`~/.claude/`) のユーザー設定。実体はこのディレクトリに置き、`link.sh` が `~/.claude/` 配下に個別 symlink を張る。

## Setup

```
cd ~/dotfiles
./link.sh
```

- `enabledPlugins` の `skill-creator` / `plugin-dev` は公式マーケットプレイスから別途インストールが必要
- `hooks/pre-commit-review.sh` は `agents/code-reviewer.md` と `agents/review-fixer.md` に依存(同梱済み)

## Files

| ファイル | 内容 |
|---|---|
| `settings.json` | モデル・テーマ・hooks・statusLine などのユーザー設定 |
| `statusline-command.sh` | 4行構成のステータスライン(Nerd Font 必須) |
| `CLAUDE.md` | グローバル指示 |
| `hooks/` | `git commit` 時の format/lint/typecheck + AI レビューゲート |
| `agents/` | hooks が呼ぶレビュー用サブエージェント定義 |

## Note

`history.jsonl` / `sessions/` / `projects/` などのランタイムデータは管理対象外。`~/.claude/` 丸ごとのリンクは行わないこと。
