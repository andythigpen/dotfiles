#!/bin/bash

if [ ! -d ~/.tmux/plugins/tpm ]; then
    echo "Installing tmux plugin manager..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

if ! type gitmux &>/dev/null; then
    wget -O /tmp/gitmux.tar.gz https://github.com/arl/gitmux/releases/download/v0.11.2/gitmux_v0.11.2_linux_amd64.tar.gz
    mkdir /tmp/gitmux
    tar -C /tmp/gitmux -xzf /tmp/gitmux.tar.gz
    cp /tmp/gitmux/gitmux $HOME/bin/
fi
