#!/bin/bash
MEMORY=$(memory_pressure | grep "System-wide memory free percentage:" | awk '{print 100-$5}')
MEMORY="${MEMORY%.*}"

sketchybar --set "$NAME" icon.color=0xffb8b0a4 label="$MEMORY%" label.color=0xffd8d0c0
