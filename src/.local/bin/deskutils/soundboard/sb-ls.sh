#!/bin/sh
# List current soundboard directory as a notification.

if [ -z "$SB_DIR" ]; then
	notify-send -u critical -a "soundboard" '$SB_DIR is unset!'
	exit 1
fi

CUR_DIR="$SB_DIR"/"$(readlink $SB_DIR/cur)"

list () {
	find "$CUR_DIR" -mindepth 1 -maxdepth 1 \( -type l -o -type d -o -type f \) -print0 |\
		xargs -0 -i{} basename {} | sort
}

notify-send \
	-a "soundboard" \
	-r 13371337 \
	"$(printf "$(basename "$CUR_DIR")\n$(list)")"
