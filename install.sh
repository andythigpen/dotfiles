#!/bin/bash

TOP=$(dirname $(readlink -f $0))

function die {
    echo $1
    exit 1
}

DEFAULT_YES=([Yy]\(es\)*\|$^)
DEFAULT_NO=([Nn]\(o\)*\|$^)

function replace_dotfile {
    if [ -e ~/.$1 ]; then
        read -p "$1 already exists. Replace [Y/n]? " choice
        if [[ "$choice" =~ $DEFAULT_YES ]]; then
            mv ~/.$1 ~/.$1.bak || die "Unable to mv: ~/.$1"
            ln -s $TOP/$1 ~/.$1 || die "Unable to install: $1"
        fi
    else
        ln -s $TOP/$1 ~/.$1 || die "Unable to install: $1"
    fi
}

echo "Updating git submodules..."
git submodule update --init

read -p "Install vim files [Y/n]? " choice
if [[ "$choice" =~ $DEFAULT_YES ]]; then
    for dotfile in vimrc vim ; do
        replace_dotfile $dotfile
    done
fi

read -p "Install bashrc [Y/n]? " choice
if [[ "$choice" =~ $DEFAULT_YES ]]; then
    if [ ! -e ~/.bashrc ]; then
        ln -s $TOP/bash/bashrc ~/.bashrc
    else
        sed -i '/### include bashrc/,/### end include/d' ~/.bashrc
        cat >> ~/.bashrc <<EOF
### include bashrc
source $TOP/bash/bashrc
### end include
EOF
    fi
fi

