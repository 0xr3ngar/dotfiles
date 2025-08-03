#!/bin/bash
DISK=$(df -H | grep -E '^(/dev/disk1s1|/System/Volumes/Data)' | awk '{print $5}')
sketchybar --set disk label="$DISK"
