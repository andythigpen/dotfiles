#!/bin/bash

TOP=$(dirname $(readlink -f $0))
DOTFILES_ROOT=$(readlink -f "$TOP/..")
source $TOP/common.sh

unlink_file() {
    unlink $1 || fail "failed to unlink $1"
    success "unlinked $1"
    # restore any backups
    if [[ -e "${link}.backup" ]]; then
        mv ${link}.backup $link || fail "Failed to move ${link}.backup to $link"
        success "moved ${link}.backup to $link"
    fi
}

uninstall_dotfiles() {
    info "Uninstalling dotfiles..."

    modules=$(find $DOTFILES_ROOT -maxdepth 1 -type d \
              -not -name '.*' \
              -not -name $(basename "$TOP") \
              -not -name $(basename "$DOTFILES_ROOT"))
    for module in $modules; do
        info "Uninstalling $(basename $module)"

        if [[ -e $module/pre-uninstall.sh ]]; then
            info "Pre-uninstall $(basename $module)"
            bash $module/pre-uninstall.sh
        fi

        for link in `find $HOME -maxdepth 1 -lname "$module/*"`; do
            unlink_file $link
        done

        if [[ -e $module/post-uninstall.sh ]]; then
            info "Post-uninstall $(basename $module)"
            bash $module/post-uninstall.sh
        fi
    done

    # remove any extra remaining links that do not match modules
    for link in `find $HOME -maxdepth 1 -lname "$DOTFILES_ROOT/*"`; do
        unlink_file $link
    done
}

echo

uninstall_dotfiles

echo
echo "Done."
