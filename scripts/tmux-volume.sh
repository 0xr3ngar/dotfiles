#!/bin/sh

/usr/bin/osascript -e 'output volume of (get volume settings)' | /usr/bin/awk '{ print $1 "%" }'
