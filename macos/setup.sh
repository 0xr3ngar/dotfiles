#!/usr/bin/env bash
# Link macOS + shared (common) configs from this repo.
# Usage: bash ~/dotfiles/macos/setup.sh
set -euo pipefail

MACOS="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$MACOS/.." && pwd)"
COMMON="$ROOT/common"

log()  { printf '\n\033[1;35m==>\033[0m %s\n' "$*"; }
ok()   { printf '  \033[1;32m✓\033[0m %s\n' "$*"; }

link() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  rm -rf "$dest"
  ln -s "$src" "$dest"
  ok "$dest → $src"
}

log "Restowing from $ROOT"

# Shared home
link "$COMMON/.gitconfig" "$HOME/.gitconfig"
link "$COMMON/.tmux.conf" "$HOME/.tmux.conf"

# macOS home
link "$MACOS/.zshrc" "$HOME/.zshrc"

# yabai / skhd expect files in $HOME
link "$MACOS/.config/yabai/skhdrc" "$HOME/.skhdrc"
link "$MACOS/.config/yabai/yabairc" "$HOME/.yabairc"

# Shared ~/.config
for dir in nvim cursor zed neofetch scripts opencode; do
  [[ -d "$COMMON/.config/$dir" ]] || continue
  link "$COMMON/.config/$dir" "$HOME/.config/$dir"
done

# macOS ~/.config
for dir in alacritty borders lazygit sketchybar yabai; do
  [[ -d "$MACOS/.config/$dir" ]] || continue
  link "$MACOS/.config/$dir" "$HOME/.config/$dir"
done

# Wallpapers → ~/.config/wallpapers (legacy path used by some scripts)
if [[ -d "$MACOS/wallpapers" ]]; then
  link "$MACOS/wallpapers" "$HOME/.config/wallpapers"
fi

printf '\nDone. Restart yabai / sketchybar / skhd if needed.\n'
