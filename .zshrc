export EDITOR="nvim"
export VISUAL="nvim"

export ZSH="$HOME/.oh-my-zsh"
export PATH="$HOME/.bun/bin:$HOME/go/bin:/usr/local/go/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

ZSH_THEME="robbyrussell"

alias v="nvim"
alias vi="nvim"
alias vim="nvim"


mkcd() { mkdir -p "$1" && cd "$1" }
killport() { lsof -ti:$1 | xargs kill -9 }
f() { open "${1:-.}" }

yabai-restart() {
  yabai --stop-service
  yabai --start-service
  skhd --stop-service
  skhd --start-service
}

borders-restart() {
  borders --stop-service
  borders --start-service
}

export BUN_INSTALL="$HOME/.bun"
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

export DOCKER_HOST="unix://${HOME}/.colima/docker.sock"
export TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE=/var/run/docker.sock

export PATH="$(brew --prefix llvm@19)/bin:$PATH"

plugins=(git)

source $ZSH/oh-my-zsh.sh

