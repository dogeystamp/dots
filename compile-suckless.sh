#!/bin/sh
# run this as root to automagically install the suckless/ utilities

set -e

if [ -z "$TARGET" ]; then
	TARGET="install"
fi

SRCFOLDER="$(dirname "$0")/suckless"

for proj in st dwm slock dmenu; do
	make -C "$SRCFOLDER"/"$proj" "$TARGET"
done
