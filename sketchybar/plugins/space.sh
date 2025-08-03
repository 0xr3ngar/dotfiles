#!/bin/bash
if [ "$SELECTED" = "true" ]; then
  sketchybar --set "$NAME" background.drawing=on \
                          label.color=0xff000000    # Black text on bright blue
else
  sketchybar --set "$NAME" background.drawing=off \
                          label.color=0xff00aeff    # Bright blue text when inactive
fi
