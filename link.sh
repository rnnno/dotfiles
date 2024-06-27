#!/bin/bash

DOTFILES_DIR="$(pwd)"
BACKUP="$HOME/.backup"

dotfiles=(
  zshenv
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

