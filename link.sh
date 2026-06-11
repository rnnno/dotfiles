#!/bin/bash

link() {
  DOTFILES_DIR="$(pwd)"
  BACKUP="$HOME/.backup"

  dotfiles=(
    zshenv
    xprofile
    editorconfig
    config
  )

  mkdir "$BACKUP"

  for f in "${dotfiles[@]}"; do
    if [ -e "$HOME/.$f" ]; then
      echo "$HOME/.$f is exist"
      echo "make backup"
      mv "$HOME/.$f" "$BACKUP/.$f"
    fi
    echo "make link $DOTFILES_DIR/$f $HOME/.$f"
    ln -snf "$DOTFILES_DIR/$f" "$HOME/.$f"
  done

}

link_claude() {
  DOTFILES_DIR="$(pwd)"
  BACKUP="$HOME/.backup"

  claude_files=(
    settings.json
    statusline-command.sh
    CLAUDE.md
    hooks/pre-commit-review.sh
    hooks/review-approve.sh
    agents/code-reviewer.md
    agents/review-fixer.md
  )

  mkdir -p "$HOME/.claude/hooks" "$HOME/.claude/agents"

  for f in "${claude_files[@]}"; do
    if [ -e "$HOME/.claude/$f" ] && [ ! -L "$HOME/.claude/$f" ]; then
      echo "$HOME/.claude/$f is exist"
      echo "make backup"
      mv "$HOME/.claude/$f" "$BACKUP/claude-${f//\//-}"
    fi
    echo "make link $DOTFILES_DIR/claude/$f $HOME/.claude/$f"
    ln -snf "$DOTFILES_DIR/claude/$f" "$HOME/.claude/$f"
  done

}

link
link_claude

