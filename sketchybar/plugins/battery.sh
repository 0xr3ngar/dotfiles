#!/bin/sh

PERCENTAGE="$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)"
CHARGING="$(pmset -g batt | grep 'AC Power')"

if [ "$PERCENTAGE" = "" ]; then
  exit 0
fi

if [ -n "$CHARGING" ]; then
  COLOR=0xffc8b468
elif [ "$PERCENTAGE" -le 20 ]; then
  COLOR=0xffe08060
else
  COLOR=0xffd8d0c0
fi

sketchybar --set "$NAME" label="BAT ${PERCENTAGE}%" label.color="$COLOR"
