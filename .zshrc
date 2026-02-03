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

function glc() {
  local count=${1:-10}
  local commits=("${(@f)$(git log --pretty=format:'%h %s' -n $count 2>/dev/null)}")
  
  if [[ ${#commits[@]} -eq 0 ]]; then
    echo "Not a git repository or no commits found"
    return 1
  fi
  
  for i in {1..${#commits[@]}}; do
    echo "$i) ${commits[$i]}"
  done
  
  echo ""
  read "choice?Enter number to copy SHA (or q to quit): "
  
  if [[ "$choice" == "q" ]]; then
    return 0
  fi
  
  if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= ${#commits[@]} )); then
    local sha="${commits[$choice]%% *}"
    echo -n "$sha" | pbcopy
    echo "Copied: $sha"
  else
    echo "Invalid selection"
    return 1
  fi
}

unalias gp 2>/dev/null
function gp() {
  local output
  
  if [[ $# -eq 0 ]] && ! git rev-parse --abbrev-ref --symbolic-full-name @{u} &>/dev/null; then
    local branch=$(git branch --show-current)
    output=$(git push -u origin "$branch" 2>&1)
  else
    output=$(git push "$@" 2>&1)
  fi
  
  local exit_code=$?
  echo "$output"
  
  local url=$(echo "$output" | grep -oE 'https://[^ ]+/pull/new/[^ ]+' | tr -d '[:space:]')
  if [[ -n "$url" ]]; then
    echo -n "$url" | pbcopy
    echo "\n✓ Copied: $url"
  fi
  
  return $exit_code
}
