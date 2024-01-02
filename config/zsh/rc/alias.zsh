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

alias :q='exit'

alias ojt='g++ main.cpp && oj t -d ./tests'
