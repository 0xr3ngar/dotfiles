export EDITOR="nvim"
export VISUAL="nvim"

# =============================================================================
# Environment
# =============================================================================

export NVM_DIR="$HOME/.nvm"
export BUN_INSTALL="$HOME/.bun"
export PNPM_HOME="$HOME/Library/pnpm"
export DOCKER_HOST="unix://$HOME/.colima/default/docker.sock"
export TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE=/var/run/docker.sock

# Machine-local secrets (gitignored)
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"

# =============================================================================
# PATH
# =============================================================================

path=(
  "$BUN_INSTALL/bin"
  "$PNPM_HOME"
  "$HOME/go/bin"
  "/usr/local/go/bin"
  "/opt/homebrew/bin"
  "/opt/homebrew/sbin"
  "/opt/homebrew/opt/llvm@19/bin"
  "/opt/homebrew/opt/postgresql@18/bin"
  "/opt/homebrew/opt/ruby@3.4/bin"
  "$HOME/.opencode/bin"
  "$HOME/.local/bin"
  $path
)
export PATH

# =============================================================================
# Completion
# =============================================================================

autoload -Uz compinit
compinit -C
zmodload -i zsh/complist

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'

# =============================================================================
# Shell Options
# =============================================================================

setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
setopt CORRECT
setopt RM_STAR_WAIT
setopt NO_CLOBBER
setopt AUTO_CD
setopt AUTO_MENU
setopt ALWAYS_TO_END
setopt COMPLETE_IN_WORD
setopt INTERACTIVE_COMMENTS
setopt NO_BEEP
setopt PROMPT_SUBST

# =============================================================================
# Prompt
# =============================================================================

autoload -Uz colors
colors

EMBER_CORAL="#e08060"
EMBER_GOLD="#c8b468"
EMBER_FG="#d8d0c0"
EMBER_FG_ALT="#b0a898"

function prompt_git_info() {
  command git rev-parse --is-inside-work-tree &>/dev/null || return

  local branch
  branch=$(command git symbolic-ref --quiet --short HEAD 2>/dev/null || command git rev-parse --short HEAD 2>/dev/null) || return

  print -r -- " %F{$EMBER_FG_ALT}[%F{$EMBER_GOLD}$branch%F{$EMBER_FG_ALT}]%f"
}

PROMPT='%F{$EMBER_CORAL}%2~%f$(prompt_git_info) %F{$EMBER_CORAL}»%f '

# =============================================================================
# Keybindings
# =============================================================================

bindkey -e

autoload -Uz up-line-or-beginning-search down-line-or-beginning-search edit-command-line
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
zle -N edit-command-line

bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey '^r' history-incremental-search-backward
bindkey '^X^E' edit-command-line

# =============================================================================
# Aliases
# =============================================================================

alias oc='opencode'
alias lg='lazygit'
alias v='nvim'
alias vim='nvim'
alias vi='nvim'
alias br='git branch --show-current'
alias reload='source ~/.zshrc'
alias tw='~/scripts/tmux-workspaces.sh'
alias l='ls -lah'
alias ll='ls -lh'
alias la='ls -lAh'
alias md='mkdir -p'

# =============================================================================
# Functions
# =============================================================================

function mkcd() { mkdir -p "$1" && cd "$1" }
function killport() { lsof -ti:$1 | xargs kill -9 }
function f() { open "${1:-.}" }

function yabai-restart() {
  yabai --stop-service
  yabai --start-service
  skhd --stop-service
  skhd --start-service
}

function borders-restart() {
  borders --stop-service
  borders --start-service
}

# Run a command and copy its stdout to the clipboard.
function copy() {
  "$@" | pbcopy
}
compdef _precommand copy

# Interactively pick a recent commit and copy its SHA.
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

# git push that auto-sets upstream and copies the PR URL.
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

# =============================================================================
# Tool initialisation
# =============================================================================

# nvm (lazy-loaded because nvm is expensive during shell startup)
function load_nvm() {
  unset -f node npm npx nvm load_nvm

  [ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && . "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
  [ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && . "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"
  [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

  "$@"
}

function node() { load_nvm node "$@" }
function npm() { load_nvm npm "$@" }
function npx() { load_nvm npx "$@" }
function nvm() { load_nvm nvm "$@" }

# bun
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# deno
[ -f "$HOME/.deno/env" ] && . "$HOME/.deno/env"

# opencode
export OPENCODE_CONFIG="$HOME/.config/opencode/opencode.json"
