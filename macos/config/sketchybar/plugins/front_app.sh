#!/bin/sh

BOX_COLOR=0x2ae08060
BORDER_COLOR=0x66e08060
TEXT_COLOR=0xffd8d0c0

if [ -z "$SPACE_INDEX" ]; then
  SPACE_INDEX="$(yabai -m query --spaces --space 2>/dev/null | jq -r '.index // empty' 2>/dev/null)"
fi

if [ -z "$SPACE_INDEX" ]; then
  exit 0
fi

APP_PATH="$(osascript \
  -e 'tell application "System Events" to set appFile to (file of first process whose frontmost is true) as alias' \
  -e 'return POSIX path of appFile' 2>/dev/null)"

if [ -n "$APP_PATH" ]; then
  APP="$(basename "$APP_PATH" .app)"
elif [ -n "$INFO" ]; then
  APP="$INFO"
else
  APP="$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null)"
fi

if [ -z "$APP" ]; then
  exit 0
fi

sketchybar --move front_app after "space.$SPACE_INDEX" \
           --set front_app label="$APP" \
                           label.color=$TEXT_COLOR \
                           width=190 \
                           background.color=$BOX_COLOR \
                           background.border_color=$BORDER_COLOR \
                           background.image="app.$APP" \
                           background.image.drawing=on \
                           background.image.scale=0.76 \
                           background.image.padding_left=10
