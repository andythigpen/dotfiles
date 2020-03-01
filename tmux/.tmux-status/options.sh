#!/bin/bash

flags=""

opt=$(tmux show-window-option synchronize-panes)
if [[ "$opt" == *"on" ]]; then
    flags="${flags}sync"
fi

# disk usage
dfree=$(df --output=pcent / | tail -1)
dcolor="white,dim"
[ ${dfree%%%} -gt 85 ] && dcolor="yellow,bold"
[ ${dfree%%%} -gt 90 ] && dcolor="red,bold"

# mem usage
mfree=$(free -t | awk 'NR == 2 {printf("%.0f%%", $3/$2*100)}')
mcolor="white,dim"
[ ${mfree%%%} -gt 85 ] && mcolor="yellow,bold"
[ ${mfree%%%} -gt 90 ] && mcolor="red,bold"

echo "  $flags #[default,dim]| #[default] #[fg=$mcolor]$mfree  #[default]#[fg=$dcolor]$dfree #[default]"
