
HISTFILE=$HOME/.zsh-history
HISTSIZE=10000
SAVEHIST=10000

autoload -Uz compinit && compinit

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:default' menu select=1

chpwd () { eza --group-directories-first --icons }

# eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(sheldon source)"

