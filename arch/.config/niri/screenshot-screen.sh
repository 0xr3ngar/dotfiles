#!/usr/bin/env bash
# Full-output screenshot → clipboard (+ optional save) + notify.
# Usage: screenshot-screen.sh [--save]
set -euo pipefail

SAVE=0
[[ "${1:-}" == "--save" ]] && SAVE=1

dir="$HOME/Pictures/Screenshots"
mkdir -p "$dir"

tmp="$(mktemp --suffix=.png)"
cleanup() { rm -f "$tmp"; }
trap cleanup EXIT

grim "$tmp"
wl-copy -t image/png < "$tmp"

notify_body="Copied to clipboard"
if [[ "$SAVE" -eq 1 ]]; then
  out="$dir/Screenshot from $(date +%Y-%m-%d\ %H-%M-%S).png"
  cp "$tmp" "$out"
  notify_body="Saved + copied\n$out"
fi

notify-send -a screenshot -i "$tmp" "Screenshot" "$notify_body" || true
