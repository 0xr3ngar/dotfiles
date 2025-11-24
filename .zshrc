# ~/.zshrc

# ─────────────────────────────────────────────────────────────
# Core
# ─────────────────────────────────────────────────────────────
export EDITOR="nvim"
export VISUAL="nvim"

# ─────────────────────────────────────────────────────────────
# Path (clean, no duplicates)
# ─────────────────────────────────────────────────────────────
export PATH="$HOME/.bun/bin:$HOME/go/bin:/usr/local/go/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

# ─────────────────────────────────────────────────────────────
# History
# ─────────────────────────────────────────────────────────────
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS

# ─────────────────────────────────────────────────────────────
# Completion
# ─────────────────────────────────────────────────────────────
autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# ─────────────────────────────────────────────────────────────
# Options
# ─────────────────────────────────────────────────────────────
setopt AUTO_CD
setopt CORRECT
setopt NO_BEEP

# ─────────────────────────────────────────────────────────────
# Keybindings
# ─────────────────────────────────────────────────────────────
bindkey -e
autoload -U up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^W' backward-kill-word

# ─────────────────────────────────────────────────────────────
# Aliases
# ─────────────────────────────────────────────────────────────
alias v="nvim"
alias vi="nvim"
alias vim="nvim"

# Git
alias gs="git status"
alias gd="git diff"
alias gc="git commit"
alias gp="git push"
alias gpf="git push --force-with-lease"
alias gl="git log --oneline -20"
alias gco="git checkout"
alias gcb="git checkout -b"
alias br="git branch --show-current"
alias lg="lazygit"

# Better defaults
alias ls="eza"
alias ll="eza -la"
alias tree="eza --tree"
alias cat="bat --plain"

# Quick edits
alias zshrc="nvim ~/.zshrc && source ~/.zshrc"
alias yabairc="nvim ~/.config/yabai/yabairc"
alias skhdrc="nvim ~/.config/skhd/skhdrc"

# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias cfg="cd ~/.config"
alias dev="cd ~/Developer"

# ─────────────────────────────────────────────────────────────
# Functions
# ─────────────────────────────────────────────────────────────
mkcd() { mkdir -p "$1" && cd "$1" }
gca() { git add -A && git commit -m "$*" }
killport() { lsof -ti:$1 | xargs kill -9 }
f() { open "${1:-.}" }

yabai-restart() {
  yabai --stop-service
  yabai --start-service
  skhd --stop-service
  skhd --start-service
}

# ─────────────────────────────────────────────────────────────
# Node (fnm)
# ─────────────────────────────────────────────────────────────
eval "$(fnm env --use-on-cd --shell zsh)"

# ─────────────────────────────────────────────────────────────
# Bun
# ─────────────────────────────────────────────────────────────
export BUN_INSTALL="$HOME/.bun"
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

# ─────────────────────────────────────────────────────────────
# Docker (Colima)
# ─────────────────────────────────────────────────────────────
export DOCKER_HOST="unix://${HOME}/.colima/docker.sock"
export TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE=/var/run/docker.sock

# ─────────────────────────────────────────────────────────────
# FZF
# ─────────────────────────────────────────────────────────────
source <(fzf --zsh)
export FZF_DEFAULT_OPTS='--height 40% --reverse --border'
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :50 {}'"

# ─────────────────────────────────────────────────────────────
# Zoxide
# ─────────────────────────────────────────────────────────────
eval "$(zoxide init zsh)"
alias cd="z"

# ─────────────────────────────────────────────────────────────
# Plugins
# ─────────────────────────────────────────────────────────────
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

# ─────────────────────────────────────────────────────────────
# Prompt (starship)
# ─────────────────────────────────────────────────────────────
eval "$(starship init zsh)"

# ─────────────────────────────────────────────────────────────
# Environment Variables
# ─────────────────────────────────────────────────────────────
