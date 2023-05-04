#!/bin/sh
# Quick editor popup

TMPFILE="$(mktemp)"

#xsel -b > "$TMPFILE"
st -g 60x8+0+800 -n popup-bottom-center \
	-e nvim -c "set binary noeol" -c "startinsert" "$TMPFILE" -c "highlight Normal ctermbg=016"
cat "$TMPFILE" | xsel -ib
rm "$TMPFILE"
