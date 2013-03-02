#!/bin/bash

TOP=$(dirname $(readlink -f $0))
DOTFILES_ROOT=$(readlink -f "$TOP/..")
source $DOTFILES_ROOT/script/common.sh

if [ -d ~/bin ]; then
    valid=false
    while [[ "$valid" == "false" ]]; do
        ask "Directory ~/bin already exists. Options\n  [r]eplace directory, [s]kip? " action
        case "$action" in
            r )
                valid=true
                mv -f ~/bin ~/bin.backup
                ;;
            s )
                exit 0
                ;;
            *) 
            ;;
        esac
    done
fi

ln -s $TOP/bin ~/bin
