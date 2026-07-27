#!/bin/sh

cores=$(/usr/sbin/sysctl -n hw.ncpu)
/bin/ps -eo pcpu= | /usr/bin/awk -v cores="$cores" '{ sum += $1 } END { printf "%.0f%%", sum / cores }'
