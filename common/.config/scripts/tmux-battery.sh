#!/bin/sh

/usr/bin/pmset -g batt | /usr/bin/awk 'NR == 2 && match($0, /[0-9]+%/) { print substr($0, RSTART, RLENGTH) }'
