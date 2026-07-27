#!/usr/bin/env bash
# Toggle maximize-column, then nudge the viewport so neighbors stay in view.
# (niri does not restore scroll position after maximize-column — known limitation)
set -euo pipefail

win=$(niri msg -j focused-window 2>/dev/null || true)
id=""
if [[ -n "$win" && "$win" != "null" ]]; then
  id=$(printf '%s' "$win" | sed -n 's/.*"id"[[:space:]]*:[[:space:]]*\([0-9][0-9]*\).*/\1/p' | head -1)
fi

niri msg action maximize-column

# Bounce focus sideways to force a viewport realign, then restore focus.
niri msg action focus-column-left || true
niri msg action focus-column-right || true
niri msg action focus-column-left || true

if [[ -n "$id" ]]; then
  niri msg action focus-window --id "$id" || true
fi
