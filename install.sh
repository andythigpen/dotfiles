#!/bin/bash

TOP=$(dirname $(readlink -f $0))

function die {
    echo $1
    exit 1
}

function install_dotfile {
    if [ -e ~/.$1 ]; then
        echo "$1 already exists. Not installing..."
    else
        ln -s $TOP/$1 ~/.$1 || die "Unable to install: $1"
    fi
}

install_dotfile vimrc
install_dotfile vim

