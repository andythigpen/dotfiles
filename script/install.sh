#!/bin/bash

# Modified from https://github.com/holman/dotfiles

TOP=$(dirname $(readlink -f $0))
DOTFILES_ROOT=$(readlink -f "$TOP/..")
source $TOP/common.sh

# exit immediately on error
set -e

link_files() {
    ln -s $1 $2 || fail "failed to link $2 -> $1"
    success "created link $2 -> $1"
}

resolve_conflict() {
    src="$1"
    dest="$2"
    overwrite=false
    backup=false
    skip=false

    if [[ -z "$overwrite_all" && -z "$backup_all" && -z "$skip_all" ]]; then
        valid=false
        while [[ "$valid" == "false" ]]; do
            ask "File already exists: `basename $dest`. Options:\n  [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?" action

            case "$action" in
                o )
                    valid=true
                    overwrite=true;;
                O )
                    valid=true
                    overwrite_all=true;;
                b )
                    valid=true
                    backup=true;;
                B )
                    valid=true
                    backup_all=true;;
                s )
                    valid=true
                    skip=true;;
                S )
                    valid=true
                    skip_all=true;;
                * )
                ;;
            esac
        done
    fi

    if [[ "$overwrite" == "true" || "$overwrite_all" == "true" ]]; then
        rm -rf $dest || fail "Failed to remove $dest"
        success "removed $dest"
    fi

    if [[ "$backup" == "true" || "$backup_all" == "true" ]]; then
        mv $dest ${dest}.backup || fail "Failed to backup $dest"
        success "moved $dest to ${dest}.backup"
    fi

    if [[ "$skip" == "true" || "$skip_all" == "true" ]]; then
        info "skipped $dest"
    else
        link_files $src $dest
    fi
}

install_dotfiles() {
    modules=$(find $DOTFILES_ROOT -maxdepth 1 -type d \
              -not -name '.*' \
              -not -name $(basename "$TOP") \
              -not -name $(basename "$DOTFILES_ROOT"))
    for module in $modules; do
        info "Installing $(basename $module)"

        if [[ -e $module/pre-install.sh ]]; then
            info "Pre-install $(basename $module)"
            bash $module/pre-install.sh
        fi

        for src in `find $module -maxdepth 1 -name \*.symlink`; do
            dest="$HOME/.`basename \"${src%.*}\"`"
            if [[ -f "$dest" || -d "$dest" || -L "$dest" ]]; then
                resolve_conflict $src $dest
            else
                link_files $src $dest
            fi
        done

        if [[ -e $module/post-install.sh ]]; then 
            info "Post-install $(basename $module)"
            bash $module/post-install.sh
        fi
    done
}

update_submodules() {
    PWD=`pwd`
    cd $DOTFILES_ROOT
    git submodule init
    git submodule update
    cd $PWD
}

echo

install_dotfiles
update_submodules

echo
echo "Done."
