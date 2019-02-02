#!/usr/bin/env bash

# terminate existing instances
killall -q polybar

# wait
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# launch
polybar main &

echo "Bars launched..."
