#!/bin/bash
set -euo pipefail

space_index=$(yabai -m query --spaces --space | jq -r '.index')

yabai -m query --windows --space "$space_index" \
  | jq -r '.[] | select(."has-ax-reference" == true) | .id' \
  | while read -r window_id; do
      yabai -m window "$window_id" --close 2>/dev/null || true
    done

for _ in {1..20}; do
  remaining_windows=$(yabai -m query --windows --space "$space_index" | jq '[.[] | select(."has-ax-reference" == true)] | length')
  [ "$remaining_windows" -eq 0 ] && break
  sleep 0.1
done

yabai -m space --destroy "$space_index"
