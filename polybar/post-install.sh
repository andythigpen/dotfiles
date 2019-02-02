#!/bin/bash

TOP=$(dirname $(readlink -f $0))
DOTFILES_ROOT=$(readlink -f "$TOP/..")
source $DOTFILES_ROOT/common.sh

which visudo &>/dev/null || fail "visudo executable not found in PATH"


sudo cp $TOP/sudoers/* /etc/sudoers.d/

for file in $TOP/sudoers/*; do
    sudo cp $file /etc/sudoers.d/
    sudo visudo -c || fail "visudo check failed"
done
