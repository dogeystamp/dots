#!/bin/sh
# wrapper to either start alacritty or just create a new window

alacritty msg create-window "$@" || alacritty "$@"
