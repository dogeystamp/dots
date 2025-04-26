#!/bin/sh
# wrapper to either start alacritty or just create a new window

if [ -n "$EYECANDY" ]; then
	neovide -- -c "set ls=0" -c "startinsert" -c "au TermClose * :qa" -c "set shell=$SHELL" -c "term $@"
else
	alacritty msg create-window "$@" || alacritty "$@"
fi
