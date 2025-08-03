#!/bin/bash

SPACE=$1

if ! yabai -m query --spaces --space "$SPACE" &>/dev/null; then
    CURRENT_SPACES=$(yabai -m query --spaces | jq '. | length')
    while [ "$CURRENT_SPACES" -lt "$SPACE" ]; do
        yabai -m space --create
        CURRENT_SPACES=$((CURRENT_SPACES + 1))
    done
fi

yabai -m window --space "$SPACE"
yabai -m space --focus "$SPACE"
