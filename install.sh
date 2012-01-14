#!/bin/bash

TOP=$(dirname $(readlink -f $0))

function die {
    echo $1
    exit 1
}

DEFAULT_YES=([Yy]\(es\)*\|$^)
DEFAULT_NO=([Nn]\(o\)*\|$^)

function install_dotfile {
    if [ -e ~/.$1 ]; then
        read -p "$1 already exists. Replace [Y/n]?" choice
        if [[ "$choice" =~ $DEFAULT_YES ]]; then
            mv ~/.$1 ~/.$1.bak || die "Unable to mv: ~/.$1"
            ln -s $TOP/$1 ~/.$1 || die "Unable to install: $1"
        fi
    else
        ln -s $TOP/$1 ~/.$1 || die "Unable to install: $1"
    fi
}

DOTFILES=( vimrc vim )

for dotfile in "${DOTFILES[@]}"; do
    install_dotfile $dotfile
done

git submodule update --init
