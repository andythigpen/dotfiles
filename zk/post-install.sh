DEFAULT_NOTEBOOK="$HOME/Notes"
mkdir -p "$DEFAULT_NOTEBOOK"

if [ ! -d "$DEFAULT_NOTEBOOK/.zk" ]; then
    zk init "$DEFAULT_NOTEBOOK"
fi
