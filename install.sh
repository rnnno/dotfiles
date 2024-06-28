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

main() {
  sudo pacman --needed --noconfirm -S - < paclist
  paru --needed --noconfirm -S - < paclist_aur

  link

  mkdir ~/.skk
  cp /usr/share/skk/SKK-JISYO.L ~/.skk
}

main
