#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
OS=$(awk -F= '/^NAME/{print $2}' /etc/os-release | tr -d '"')

source $DIR/common.sh

DEPS=(stow silversearcher-ag build-essential cmake python3-dev ripgrep)

if [ "$OS" = "Ubuntu" ]; then
    info "Installing package dependencies"
    sudo apt install ${DEPS[*]}
else
    warn "Dependency installation not supported for $OS."
    warn "The following requirements should be installed manually:"
    warn ""
    warn "${DEPS[*]}"
    read -n1 -r -p 'Press any key to continue...' key
fi

if [ "$#" -eq 0 ]; then
    info "Installing all packages"
    PKGS=$(ls -d */)
    SHOULD_CONFIRM=1
else
    PKGS="${@}"
    SHOULD_CONFIRM=0
fi

pushd $DIR &>/dev/null
for pkg in $PKGS; do
    pkg=${pkg%%/}
    if [ $SHOULD_CONFIRM -eq 1 ] && ! confirm "Install $pkg package?"; then
        continue
    fi
    info "Installing $pkg"
    stow --ignore=post-install.sh -v $pkg
    if [ $? -eq 0 ]; then
        if [ -f "$pkg/post-install.sh" ]; then
            info "Running post install for $pkg"
            bash "$pkg/post-install.sh"
        fi
        success "Installed $pkg"
    else
        fail "Failed to install $pkg"
    fi
done
popd &>/dev/null
