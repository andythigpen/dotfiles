#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/common.sh

if [ "$#" -eq 0 ]; then
    info "Uninstalling all packages"
    PKGS=$(ls -d */)
else
    PKGS="${@}"
fi

pushd $DIR &>/dev/null
for pkg in $PKGS; do
    pkg=${pkg%%/}
    info "Uninstalling $pkg"
    stow --ignore=post-install.sh -v -D $pkg
    if [ $? -eq 0 ]; then
        success "Uninstalled $pkg"
    else
        fail "Failed to uninstall $pkg"
    fi
done
popd &>/dev/null
