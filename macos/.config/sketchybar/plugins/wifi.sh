#!/bin/bash
WIFI_SSID=$(ipconfig getsummary en0 | awk -F ' SSID : '  '/ SSID : / {print $2}')
sketchybar --set wifi label="${WIFI_SSID:-"No WiFi"}"
