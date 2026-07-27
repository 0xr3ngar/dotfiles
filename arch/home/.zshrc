# ~/.zshrc — interactive zsh

export EDITOR=nvim
export VISUAL=nvim
export OPENCODE_CONFIG="$HOME/.config/opencode/opencode.jsonc"

# -----------------------------------------------------------------------------
# PATH (deduped; only real directories)
# -----------------------------------------------------------------------------

typeset -U path
for dir in \
  "$HOME/.bun/bin" \
  "$HOME/.local/bin"
do
  [[ -d $dir ]] && path=($dir $path)
done

# -----------------------------------------------------------------------------
# History / options
# -----------------------------------------------------------------------------

HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000

setopt SHARE_HISTORY EXTENDED_HISTORY HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS
setopt AUTO_CD AUTO_MENU COMPLETE_IN_WORD ALWAYS_TO_END INTERACTIVE_COMMENTS
setopt CORRECT NO_CLOBBER NO_BEEP PROMPT_SUBST RM_STAR_WAIT

# -----------------------------------------------------------------------------
# Completion
# -----------------------------------------------------------------------------

autoload -Uz compinit && compinit -C
zmodload -i zsh/complist
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'

# -----------------------------------------------------------------------------
# Prompt (God-King)
# -----------------------------------------------------------------------------

autoload -Uz colors && colors

_gk_git() {
  git rev-parse --is-inside-work-tree &>/dev/null || return
  local b
  b=$(git symbolic-ref --quiet --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null) || return
  print -r -- " %F{#9a9aac}[%F{#c9a06a}$b%F{#9a9aac}]%f"
}

_gk_exit() {
  local e=$?
  (( e )) && print -r -- "%F{#d33355}✗ $e%f "
}

PROMPT='$(_gk_exit)%F{#d33355}%2~%f$(_gk_git) %F{#d33355}»%f '

# -----------------------------------------------------------------------------
# Keybindings
# -----------------------------------------------------------------------------

bindkey -e
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search edit-command-line
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
zle -N edit-command-line
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey '^[[Z' reverse-menu-complete
bindkey -M menuselect '^[[Z' reverse-menu-complete
bindkey '^r' history-incremental-search-backward
bindkey '^X^E' edit-command-line

# -----------------------------------------------------------------------------
# Aliases
# -----------------------------------------------------------------------------

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias l='ls -lah'
alias ll='ls -lh'
alias la='ls -lAh'
alias md='mkdir -p'
alias v='nvim'
alias vi='nvim'
alias vim='nvim'
alias oc='opencode'
alias lg='lazygit'
alias br='git branch --show-current'
alias reload='source ~/.zshrc'

# -----------------------------------------------------------------------------
# Functions
# -----------------------------------------------------------------------------

mkcd() { mkdir -p "$1" && cd "$1" }

f() { xdg-open "${1:-.}" &>/dev/null & }

killport() {
  [[ -z $1 ]] && { echo "Usage: killport <port>"; return 1 }
  local pids=($(ss -H -lptn "sport = :$1" 2>/dev/null | grep -oP 'pid=\K[0-9]+' | sort -u))
  (( $#pids )) || { echo "Nothing on port $1"; return 1 }
  kill -9 $pids && echo "Killed: $pids"
}

glc() {
  local count=${1:-10}
  local commits=("${(@f)$(git log --pretty=format:'%h %s' -n $count 2>/dev/null)}")
  (( $#commits )) || { echo "No commits"; return 1 }

  local i
  for i in {1..$#commits}; do echo "$i) ${commits[$i]}"; done
  echo
  read "choice?Copy SHA # (q quits): "
  [[ $choice == q ]] && return
  [[ $choice =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= $#commits )) || { echo "Invalid"; return 1 }

  local sha=${commits[$choice]%% *}
  print -n -- "$sha" | wl-copy
  echo "Copied: $sha"
}

gsw() {
  [[ $# -eq 1 ]] || { echo "Usage: gsw <branch>"; return 1 }
  local b=$1
  if git show-ref --verify --quiet "refs/heads/$b"; then
    git switch "$b"
  elif git show-ref --verify --quiet "refs/remotes/origin/$b"; then
    git switch --track "origin/$b"
  else
    git switch -c "$b"
  fi
}

gp() {
  local output
  if [[ $# -eq 0 ]] && ! git rev-parse --abbrev-ref --symbolic-full-name @{u} &>/dev/null; then
    output=$(git push -u origin "$(git branch --show-current)" 2>&1)
  else
    output=$(git push "$@" 2>&1)
  fi
  local ec=$?
  print -r -- "$output"
  local url=$(print -r -- "$output" | grep -oE 'https://[^ ]+/pull/new/[^ ]+' | tr -d '[:space:]')
  [[ -n $url ]] && { print -n -- "$url" | wl-copy; echo "\n✓ Copied: $url" }
  return $ec
}

# -----------------------------------------------------------------------------
# Tools
# -----------------------------------------------------------------------------

eval "$(zoxide init zsh --cmd cd)"

# Machine-local overrides last
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
