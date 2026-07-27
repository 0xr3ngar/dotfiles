#!/bin/sh

/usr/bin/memory_pressure | /usr/bin/awk '/System-wide memory free percentage:/ { value = 100 - $5; printf "%.0f%%", value }'
