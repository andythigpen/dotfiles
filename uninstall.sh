#!/bin/bash

TOP=$(dirname $(readlink -f $0))

function die {
    echo $1
    exit 1
}

DEFAULT_YES=([Yy]\(es\)*\|$^)
DEFAULT_NO=([Nn]\(o\)*\|$^)

function uninstall_dotfile {
    unlink ~/.$1 || die "Unlink ~/.$1 failed"
    if [ -e ~/.$1.bak ]; then
        read -p "$1 backup exists. Restore [Y/n]?" choice
        if [[ "$choice" =~ $DEFAULT_YES ]]; then
            mv ~/.$1.bak ~/.$1 || die "Unable to mv: ~/.$1"
        fi
    fi
}

DOTFILES=( vimrc vim )

for dotfile in "${DOTFILES[@]}"; do
    uninstall_dotfile $dotfile
done

