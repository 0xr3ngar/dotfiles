#!/bin/bash

# chatgpt'd the shit out of this lol, thanks claude 

if [ "$1" != "window_destroyed" ]; then
    exit 0
fi

sleep 0.1

CURRENT_SPACE=$(yabai -m query --spaces --space)
SPACE_INDEX=$(echo "$CURRENT_SPACE" | jq '.index')
TOTAL_SPACES=$(yabai -m query --spaces | jq '. | length')

ALL_WINDOWS=$(yabai -m query --windows --space "$SPACE_INDEX")
WINDOW_COUNT=$(echo "$ALL_WINDOWS" | jq '. | length')

NON_FINDER_COUNT=$(echo "$ALL_WINDOWS" | jq '[.[] | select(.app != "Finder")] | length')

if [ "$NON_FINDER_COUNT" -gt 0 ]; then
    yabai -m window --focus recent || yabai -m window --focus first
    exit 0
fi

if [ "$NON_FINDER_COUNT" -eq 0 ] && [ "$WINDOW_COUNT" -gt 0 ]; then
    echo "$ALL_WINDOWS" | jq -r '.[] | select(.app == "Finder") | .id' | while read -r finder_id; do
        yabai -m window "$finder_id" --close
    done
fi

if [ "$TOTAL_SPACES" -gt 1 ]; then
    sleep 0.1
    
    REMAINING=$(yabai -m query --windows --space "$SPACE_INDEX" | jq '. | length')
    
    if [ "$REMAINING" -eq 0 ]; then
        POPULATED_SPACE=$(yabai -m query --spaces | jq -r '.[] | select(.windows | length > 0) | .index' | head -1)
        
        if [ -n "$POPULATED_SPACE" ]; then
            yabai -m space --focus "$POPULATED_SPACE"
            yabai -m space "$SPACE_INDEX" --destroy
        fi
    fi
fi
