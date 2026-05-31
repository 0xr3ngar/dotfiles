#!/bin/bash
# restow.sh - Re-create all symlinks from this dotfiles repo

set -e

echo "Restowing dotfiles from $(pwd)..."

# Home files
HOME_FILES=(".zshrc" ".gitconfig" ".tmux.conf")
for file in "${HOME_FILES[@]}"; do
    target="$HOME/$file"
    source="$(pwd)/$file"
    rm -f "$target"
    ln -s "$source" "$target"
    echo "  ~/$file"
done

# ~/.config folders
CONFIG_FOLDERS=(
    alacritty borders cursor i3 i3status lazygit
    neofetch nvim opencode picom scripts sketchybar
    wallpapers yabai zed
)
for folder in "${CONFIG_FOLDERS[@]}"; do
    target="$HOME/.config/$folder"
    source="$(pwd)/$folder"
    rm -rf "$target"
    ln -s "$source" "$target"
    echo "  ~/.config/$folder"
done

echo
echo "Done. You may need to restart some applications (yabai, sketchybar, etc.)."
