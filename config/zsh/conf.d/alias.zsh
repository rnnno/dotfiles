alias ce='clear'
alias cc='cd && ce'

alias ll='eza --group-directories-first -lF --icons'
alias lla='ll -a'
alias la='ll -a'
alias tree='ll --tree'

function mkcd() {
    mkdir $* && cd $_
}
alias mkcd="mkcd"

alias v='nvim'
alias vim='nvim'

alias bat='bat --style=numbers'

alias sudo='sudo '
alias :q='exit'
alias so='source ~/.config/zsh/.zshrc'
alias dotfiles='cd ~/dotfiles'

function my_bd () {
  if [[ $# -eq 0 ]]; then
    bd 1
  else
    bd "$@"
  fi
}
alias bd="my_bd"

alias ojt='g++ main.cpp && oj t -d ./tests'

alias wsl='cd /mnt/c/Users/moto/'
alias document='cd /mnt/c/Users/moto/OneDrive/ドキュメント'

