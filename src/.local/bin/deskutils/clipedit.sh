#!/bin/sh
# Edit clipboard contents with $EDITOR

TMPFILE="$(mktemp)"

xsel -b > "$TMPFILE"
nvim "$TMPFILE"
cat "$TMPFILE" | xsel -ib
rm "$TMPFILE"
