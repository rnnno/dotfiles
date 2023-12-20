#!/usr/bin/env bash


install_brew_file() {
  if [[ !command -v brew &> /dev/null ]]; then
    echo "Homebrew is not installed. Install Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
    echo "Homebrew is already installed."
  fi

  # TODO: やる
  brew bundle install --file=brewfile
  
}

make_backup() {
  echo "make backup..."
  backup_path="$HOME/.backup"

  if [[ ! -d "$backup_path" ]]; then
    mkdir -p "b$ackup_path"
  fi

  for f in [".zshrc" ".zshenv" ".config"]
  do
    if [[ -e "$HOME/$f" ]]; then
      mv "$HOME/$f" "$backup_path/"
      echo "Backup: $f -> $backup_path/$f"
    fi
    echo "$f"
  done
  
}

create_link() {
  DOT_DIR="$HOME/dotfiles"
  for f in *;
  do
    [[ "$f" == ".git" ]] && continue
    [[ "$f" == ".gitignore" ]] && continue
    [[ "$f" == "install.sh" ]] && continue
    [[ "$f" == "README.md" ]] && continue
    
    ln -snf "$DOT_DIR/$f" "$HOME/.$f"
    echo "Linked .$f"

}


main() {
  make_backup
  create_link

}

main
