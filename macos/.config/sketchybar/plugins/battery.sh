#!/bin/sh

PERCENTAGE="$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)"
CHARGING="$(pmset -g batt | grep 'AC Power')"

if [ "$PERCENTAGE" = "" ]; then
  exit 0
fi

if [ -n "$CHARGING" ]; then
  COLOR=0xffb8b0a4
  ICON="􀢋"
elif [ "$PERCENTAGE" -le 20 ]; then
  COLOR=0xffd08770
  ICON="􀛪"
elif [ "$PERCENTAGE" -le 40 ]; then
  COLOR=0xffb8b0a4
  ICON="􀛩"
elif [ "$PERCENTAGE" -le 65 ]; then
  COLOR=0xffb8b0a4
  ICON="􀺶"
elif [ "$PERCENTAGE" -le 85 ]; then
  COLOR=0xffb8b0a4
  ICON="􀺸"
else
  COLOR=0xffb8b0a4
  ICON="􀛨"
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label="${PERCENTAGE}%" label.color=0xffd8d0c0
