export ZDOTDIR=$HOME/.config/zsh
export STARSHIP_CONFIG=$HOME/.config/starship/starship.toml

typeset -U path PATH

export CARGO_HOME=$HOME/.cargo
export DENO_INSTALL=$HOME/.deno
export DOTNET_ROOT=$HOME/.dotnet
export GOPATH=$HOME/go
export VOLTA_HOME=$HOME/.volta

typeset -ga tool_paths=(
  $HOME/.rbenv/shims
  /home/linuxbrew/.linuxbrew/bin
  $VOLTA_HOME/bin
  $GOPATH/bin
  $DOTNET_ROOT
  $DENO_INSTALL/bin
  $CARGO_HOME/bin
  $HOME/.local/bin
  $HOME/.nix-profile/bin
)
path=($tool_paths $path)

export EDITOR=nvim
export LANG=en_US.UTF-8
