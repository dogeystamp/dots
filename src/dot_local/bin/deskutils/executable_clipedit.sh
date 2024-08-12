#!/bin/sh
# Quick editor popup

TMPFILE="$(mktemp)"

xsel -b > "$TMPFILE"

newterm() {
	alacritty msg create-window "$@" ||
		alacritty "$@"
}

newterm \
	-o 'window.class = { instance = "popup-bottom-center", general="popup-bottom-center" }' \
	-o 'window.opacity = 1.0' \
	-o 'window.dimensions = { columns = 84, lines = 10 }' \
	-o 'window.position = { x = 0, y = 1200 }' \
	-e sh -c "xsel -b > '$TMPFILE'; nvim -c 'set binary noeol textwidth=80' '$TMPFILE' && cat '$TMPFILE' | xsel -ib && rm '$TMPFILE'"
