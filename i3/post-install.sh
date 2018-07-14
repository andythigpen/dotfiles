#!/bin/bash
TOP=$(dirname $(readlink -f $0))

echo "Installing gnome-terminal theme..."
bash $TOP/gnome-terminal.sh
