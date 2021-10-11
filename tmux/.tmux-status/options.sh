#!/bin/bash

flags=""

opt=$(tmux show-window-option synchronize-panes)
if [[ "$opt" == *"on" ]]; then
    flags="${flags}#[fg=yellow,bold]sync"
fi

# disk usage
dfree=$(df --output=pcent / | tail -1)
dcolor="colour245,dim"
[ ${dfree%%%} -gt 85 ] && dcolor="yellow,bold"
[ ${dfree%%%} -gt 90 ] && dcolor="red,bold"

# mem usage
mfree=$(free -t | awk 'NR == 2 {printf("%.0f%%", $3/$2*100)}')
mcolor="colour245,dim"
[ ${mfree%%%} -gt 85 ] && mcolor="yellow,bold"
[ ${mfree%%%} -gt 90 ] && mcolor="red,bold"

targets=$(toggle-target status)

divider="#[fg=colour237,dim]|#[default]"

echo "  $flags $divider $targets $divider #[fg=$mcolor] $mfree  #[fg=$dcolor]$dfree $divider"
