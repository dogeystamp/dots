#!/bin/sh
# clipboard wrapper

no_provider () {
	echo "no providers for clipboard found!"
	echo "supported: termux-api, xsel, xclip"
}

if [ "$1" = "set" ]; then
	if command -v xsel > /dev/null; then
		xsel -ib
	elif command -v termux-clipboard-set > /dev/null; then
		cat /dev/stdin | termux-clipboard-set
	else
		no_provider
	fi
elif [ "$1" = "get" ]; then
	if command -v xsel > /dev/null; then
		xsel -b
	elif command -v termux-clipboard-set > /dev/null; then
		termux-clipboard-get
	else
		no_provider
	fi
else
	echo "usage: cb.sh get/set"
	echo "pipe in data"
fi
