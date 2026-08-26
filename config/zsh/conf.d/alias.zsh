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

# alias vi='nvim'
# alias vim='nvim'

alias bat='bat --style=numbers'

alias sudo='sudo '
alias :q='exit'
alias :e=$EDITOR
alias so='source ~/.config/zsh/.zshrc'
alias dotfiles='cd ~/dotfiles'

