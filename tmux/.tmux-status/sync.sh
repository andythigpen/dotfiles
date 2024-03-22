#!/bin/bash

thm_red="#f38ba8"
catppuccin_window_left_separator=""
catppuccin_window_right_separator=""
opt=$(tmux show-window-option -v synchronize-panes)
if [[ "$opt" == *"on" ]]; then
    echo "#[fg=$thm_red]${catppuccin_window_left_separator}#[fg=#1e1e2e,bold,bg=$thm_red]SYNC#[fg=$thm_red,bg=default]${catppuccin_window_right_separator} "
fi
