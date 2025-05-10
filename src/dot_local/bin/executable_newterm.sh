#!/bin/sh
# wrapper to either start alacritty or just create a new window

if [ -n "$EYECANDY" ]; then
	exec neovide -- -u "$XDG_CONFIG_HOME/nvim/init_term.vim" -c "startinsert" -c "set shell=$SHELL" -c "term $@"
else
	alacritty msg create-window "$@" || exec alacritty "$@"
fi
