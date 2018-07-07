#
# Common functions used by scripts
# Source this file from a script to use it.
#

info() {
    printf "\r  [\033[00;34mINFO\033[0m] $1\n"
}

ask() {
    printf "\r  [ \033[0;33m??\033[0m ] $1 "
    read $2
}

success() {
    printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

warn() {
    printf "\r\033[2K  [\033[0;31mWARN\033[0m] $1\n"
}

fail() {
    printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
    echo ''
    exit
}

