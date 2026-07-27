#!/usr/bin/env bash
# Region screenshot → clipboard (+ optional save) + notify.
# Usage: screenshot-region.sh [--save]
set -euo pipefail

source "$HOME/.config/theme/colors.env"

SAVE=0
[[ "${1:-}" == "--save" ]] && SAVE=1

dir="$HOME/Pictures/Screenshots"
mkdir -p "$dir"

# slurp selection border matches accent
region="$(slurp -d -b "${bg}66" -c "${accent}ff" -s "${accent_dim}88" -w 2)" || exit 0
[[ -z "$region" ]] && exit 0

tmp="$(mktemp --suffix=.png)"
cleanup() { rm -f "$tmp"; }
trap cleanup EXIT

grim -g "$region" "$tmp"

wl-copy -t image/png < "$tmp"

notify_body="Copied to clipboard"
if [[ "$SAVE" -eq 1 ]]; then
  out="$dir/Screenshot from $(date +%Y-%m-%d\ %H-%M-%S).png"
  cp "$tmp" "$out"
  notify_body="Saved + copied\n$out"
fi

notify-send -a screenshot -i "$tmp" "Screenshot" "$notify_body" || true
