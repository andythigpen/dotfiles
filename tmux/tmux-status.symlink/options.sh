#!/bin/bash

flags=""

opt=$(tmux show-window-option synchronize-panes)
if [[ "$opt" == *"on" ]]; then
    flags="${flags}s"
fi

echo "[$flags]"
