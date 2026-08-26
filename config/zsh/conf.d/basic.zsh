
HISTFILE=$HOME/.zsh-history
HISTSIZE=10000
SAVEHIST=10000

for brew_bin in /opt/homebrew/bin/brew /home/linuxbrew/.linuxbrew/bin/brew /usr/local/bin/brew; do
  [[ -x $brew_bin ]] || continue
  brew_cache=${XDG_CACHE_HOME:-$HOME/.cache}/zsh/brew-shellenv.zsh
  if [[ ! -f $brew_cache || $brew_bin -nt $brew_cache ]]; then
    mkdir -p ${brew_cache:h}
    $brew_bin shellenv >| $brew_cache
  fi
  source $brew_cache
  break
done
unset brew_bin brew_cache

(( $+commands[sheldon] )) && eval "$(sheldon source)"

# brew と sheldon が fpath を広げた後に走らせる
autoload -Uz compinit
zcompdump_fresh=($ZDOTDIR/.zcompdump(N.mh-24))
if (( $#zcompdump_fresh )) && [[ ! ${XDG_CONFIG_HOME:-$HOME/.config}/sheldon/plugins.toml -nt $ZDOTDIR/.zcompdump ]]; then
  compinit -C
else
  compinit
  touch $ZDOTDIR/.zcompdump
fi
unset zcompdump_fresh

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:default' menu select=1

(( $+commands[eza] )) && chpwd() { eza --group-directories-first --icons }

# 初回呼び出しまで init を遅延する
if (( $+commands[rbenv] )); then
  rbenv() {
    unfunction rbenv
    eval "$(command rbenv init - --no-rehash zsh)"
    rbenv "$@"
  }
fi
