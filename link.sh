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

  mkdir -p "$BACKUP"

  for f in "${dotfiles[@]}"; do
    if [ -e "$HOME/.$f" ] && [ ! -L "$HOME/.$f" ]; then
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
    hooks/plan-review.sh
    agents/code-reviewer.md
    agents/review-fixer.md
    agents/verifier.md
    agents/judge.md
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

  [ -f "$HOME/.claude/CLAUDE.local.md" ] || touch "$HOME/.claude/CLAUDE.local.md"

}

link_skills() {
  DOTFILES_DIR="$(pwd)"
  BACKUP="$HOME/.backup"
  SKILLS_SRC="$DOTFILES_DIR/skills"

  skill_dests=(
    "$HOME/.claude/skills"
    "$HOME/.agents/skills"
  )

  mkdir -p "$BACKUP"

  for dest in "${skill_dests[@]}"; do
    mkdir -p "$dest"
    label="$(basename "$(dirname "$dest")")"

    for src in "$SKILLS_SRC"/*/; do
      [ -d "$src" ] || continue
      name="$(basename "$src")"
      target="$dest/$name"

      if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo "$target is exist"
        echo "make backup"
        backup_target="$BACKUP/${label#.}-skills-$name"
        i=2
        while [ -e "$backup_target" ]; do
          backup_target="$BACKUP/${label#.}-skills-$name.$i"
          i=$((i + 1))
        done
        mv "$target" "$backup_target"
      fi

      echo "make link $SKILLS_SRC/$name $target"
      ln -snf "$SKILLS_SRC/$name" "$target"
    done
  done

}

link
link_claude
link_skills
