#!/bin/bash
MEMORY=$(memory_pressure | grep "System-wide memory free percentage:" | awk '{print 100-$5}')
sketchybar --set memory label="MEM ${MEMORY%.*}%"
