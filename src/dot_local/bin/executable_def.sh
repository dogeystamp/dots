#!/bin/sh
# sdcv dictionary wrapper (for HTML rendering)

sdcv -n --utf8-output "$@" 2>&1 | \
	w3m -T text/html -dump -
