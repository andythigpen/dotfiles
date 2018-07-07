#!/bin/bash

TOP=$(dirname $(readlink -f $0))
DOTFILES_ROOT=$(readlink -f "$TOP/..")
source $DOTFILES_ROOT/common.sh

which git &>/dev/null || fail "git executable not found in PATH"

name=$(git config --get user.name || echo $GIT_AUTHOR_NAME)
while [[ -z "$name" ]]; do
    ask "What is your full name? " name
done

email=$(git config --get user.email || echo $GIT_AUTHOR_EMAIL)
while [[ -z "$email" ]]; do
    ask "What is your email? " email
done

cat <<EOF > $TOP/.gitauthor
[user]
    name = $name
    email = $email
EOF
