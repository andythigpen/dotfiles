#!/bin/bash

TOP=$(dirname $(readlink -f $0))
DOTFILES_ROOT=$(readlink -f "$TOP/..")
source $DOTFILES_ROOT/script/common.sh

# The name/email options are dynamically copied into gitconfig.symlink
# on a per-installation basis, since I did not want those values
# commited to the repository.
#
# This is because only git 1.7.10+ supports storing global config
# options outside of .gitconfig and including them using include.path,
# otherwise I would have used that functionality to store the name/email
# separately.

which git &>/dev/null || fail "git executable not found in PATH"

if [ -e $TOP/gitconfig.symlink ]; then
    ask "Update existing configuration? [y/N] " choice
    [ "$choice" != "y" ] && exit 0
fi
cp -f $TOP/gitconfig.template $TOP/gitconfig.symlink

name=$(git config --get user.name || echo $GIT_AUTHOR_NAME)
while [[ -z "$name" ]]; do
    ask "What is your full name? " name
done
sed -i "s/name = /name = $name/" $TOP/gitconfig.symlink

email=$(git config --get user.email || echo $GIT_AUTHOR_EMAIL)
while [[ -z "$email" ]]; do
    ask "What is your email? " email
done
sed -i "s/email = /email = $email/" $TOP/gitconfig.symlink

