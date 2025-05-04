#
# Common functions used by scripts
# Source this file from a script to use it.
#

info() {
    printf "\r  [\033[00;34mINFO\033[0m] %s\n" "$1"
}

ask() {
    printf "\r  [ \033[0;33m??\033[0m ] %s " "$1"
    read -r "$2"
}

# prompts the user to make a y/n choice
# 1: prompt text
# 2: default answer (one of 'y' or 'n')
confirm() {
    local default
    default=$(echo "$2" | tr '[:upper:]' '[:lower:]')
    [ -z "$default" ] && default="y"

    local choices
    choices=$(echo '[y/n]' | tr "$default" "$(echo "$default" | tr '[:lower:]' '[:upper:]')")

    while true; do
        printf "\r  [ \033[0;33m??\033[0m ] %s %s " "$1" "$choices"
        read -r choice
        choice=$(echo "$choice" | tr '[:upper:]' '[:lower:]')
        [ -z "$choice" ] && choice=$default
        [ "$choice" = "y" ] && return 0
        [ "$choice" = "n" ] && return 1
        warn "Unrecognized choice: $choice"
    done
}

success() {
    printf "\r\033[2K  [ \033[00;32mOK\033[0m ] %s\n" "$1"
}

warn() {
    printf "\r\033[2K  [\033[0;31mWARN\033[0m] %s\n" "$1"
}

fail() {
    printf "\r\033[2K  [\033[0;31mFAIL\033[0m] %s\n" "$1"
    echo ''
    exit
}
