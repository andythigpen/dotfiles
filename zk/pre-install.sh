VERSION="v0.15.1"
URL="https://github.com/zk-org/zk/releases/download/$VERSION/zk-$VERSION-linux-amd64.tar.gz"

if type zk &>/dev/null; then
    exit 0
fi

DEST=/tmp/zk-${VERSION}.tar.gz
DIR=$(dirname $DEST)
echo "Downloading zk $VERSION"
curl -o "$DEST" -L "$URL"
tar -C "$DIR" -xzf "$DEST"
mv "$DIR/zk" "$HOME/.local/bin/"
