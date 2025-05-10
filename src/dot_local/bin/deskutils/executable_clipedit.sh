#!/bin/sh
# Quick editor popup

TMPFILE="$(mktemp)"

cb > "$TMPFILE"

alacritty \
	-o 'window.class = { instance = "popup-bottom-center", general="popup-bottom-center" }' \
	-o 'window.dimensions = { columns = 84, lines = 10 }' \
	-o 'window.position = { x = 0, y = 1200 }' \
	-e sh -c "cb > '$TMPFILE'; nvim -c 'set binary noeol textwidth=80' '$TMPFILE' && cat '$TMPFILE' | cb set && rm '$TMPFILE'"
