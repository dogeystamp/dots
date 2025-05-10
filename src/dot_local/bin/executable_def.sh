#!/bin/sh
# sdcv dictionary wrapper (for HTML rendering)
# requires gnu sed for formatting tweaks

cyan=$(echo -ne "\e[0;36m")
reset=$(echo -ne "\e[0m")

sdcv -n --utf8-output "$@" 2>&1 \
	| elinks -dump -dump-color-mode 1 -no-references -no-connect -localhost \
	| sed -E 's/Found.*similar to [a-zA-Z]+\.//g' \
	| sed -E "s/[ ]{2,}-->/\n$cyan\n-->/g" \
	| sed "s/ -->/$reset\n\n/g"
