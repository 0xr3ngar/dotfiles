#!/bin/bash

ACTIVE_COLOR=0xffe08060
INACTIVE_COLOR=0xffb8ad9d
CLEAR_COLOR=0x001c1b19
ACTIVE_BACKGROUND=0x33e08060

if [ "$SELECTED" = "true" ]; then
    sketchybar --set "$NAME" icon.color=$ACTIVE_COLOR \
                              y_offset=4 \
                              background.color=$ACTIVE_BACKGROUND \
                              background.height=24
else
    sketchybar --set "$NAME" icon.color=$INACTIVE_COLOR \
                              y_offset=4 \
                              background.color=$CLEAR_COLOR \
                              background.height=24
fi
