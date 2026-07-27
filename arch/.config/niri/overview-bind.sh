#!/usr/bin/env bash
# Dual-bind: different niri actions in overview vs normal mode.
# Usage: overview-bind.sh <action-if-overview> <action-if-normal>
set -euo pipefail

overview_action=${1:?}
normal_action=${2:?}

state=$(niri msg -j overview-state)

case "$state" in
  *'"is_open":true'*)
    niri msg action "$overview_action"
    ;;
  *)
    niri msg action "$normal_action"
    ;;
esac
