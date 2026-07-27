#!/bin/sh

# The volume_change event supplies a $INFO variable in which the current volume
# percentage is passed to the script.

if [ "$SENDER" = "mouse.clicked" ]; then
  if [ "$BUTTON" = "right" ]; then
    open 'x-apple.systempreferences:com.apple.Sound-Settings.extension'
  else
    sketchybar --set "$NAME" popup.drawing=toggle
  fi
  exit 0
fi

if [ "$SENDER" = "volume_change" ] && [ -n "$INFO" ]; then
  VOLUME="$INFO"
else
  VOLUME="$(osascript -e 'output volume of (get volume settings)')"
fi

if [ "$VOLUME" -eq 0 ]; then
  ICON="􀊣"
elif [ "$VOLUME" -ge 80 ]; then
  ICON="􀊩"
elif [ "$VOLUME" -ge 60 ]; then
  ICON="􀊧"
else
  ICON="􀊥"
fi

sketchybar --set "$NAME" icon="$ICON" icon.color=0xffb8b0a4 label="$VOLUME%" label.color=0xffd8d0c0
