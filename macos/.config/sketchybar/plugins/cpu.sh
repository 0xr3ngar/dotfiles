#!/bin/bash
CORE_COUNT=$(sysctl -n hw.ncpu)
CPU_INFO=$(ps -eo pcpu,user)
CPU_SYS=$(echo "$CPU_INFO" | grep -v USER | awk '{sum+=$1} END {printf "%.0f\n", sum/'"$CORE_COUNT"'}')

sketchybar --set "$NAME" icon.color=0xffb8b0a4 label="$CPU_SYS%" label.color=0xffd8d0c0
