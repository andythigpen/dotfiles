#!/bin/bash
if ! grep '[ -f ~/.bashrc_ext ] && source ~/.bashrc_ext' ~/.bashrc &>/dev/null; then
    echo '[ -f ~/.bashrc_ext ] && source ~/.bashrc_ext' >> ~/.bashrc
fi
