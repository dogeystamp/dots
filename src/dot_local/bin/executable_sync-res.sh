#!/bin/sh
# Resolve Syncthing conflicts
# depends: trash-cli

col() {
	printf "\033[34m %s \033[0m" "$1"
}

die() {
	echo $@ 2>&1 
	exit 1
}

PROGNAME=$(basename "$0")
if [ -z "$1" ]; then
	die usage: $PROGNAME file.sync-conflict-XXXXXXXX-XXXXXX-XXXXXXX
fi

ORIG=$(echo "$1" | sed -E 's/\.sync-conflict-[0-9]{8}-[0-9]{6}-[A-Z]{7}//')

if [ "$ORIG" = "$1" ]; then
	die Could not find original file. Is this a sync-conflict file?
else
	printf "Using original file '%s'.\n" "$ORIG"
fi

diff --color=always "$1" "$ORIG" > /dev/tty
trash -i "$1"
