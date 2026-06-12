#!/bin/sh

if [ "$SENDER" = "mouse.clicked" ]; then
  osascript -e "set volume output volume $PERCENTAGE"
  sketchybar --set "$NAME" slider.percentage="$PERCENTAGE" \
             --trigger volume_change INFO="$PERCENTAGE"
  exit 0
fi

if [ "$SENDER" = "mouse.exited" ]; then
  sleep 1
  sketchybar --set volume popup.drawing=off
  exit 0
fi

if [ "$SENDER" = "volume_change" ] && [ -n "$INFO" ]; then
  sketchybar --set "$NAME" slider.percentage="$INFO"
  exit 0
fi

VOLUME="$(osascript -e 'output volume of (get volume settings)')"
sketchybar --set "$NAME" slider.percentage="$VOLUME"
