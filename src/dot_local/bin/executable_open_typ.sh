#!/bin/sh
# opens corresponding .typ to current .pdf

alacritty -e nvim $(printf "%s/%s.typ" $(dirname "$1") $(basename -s .pdf "$1"))
