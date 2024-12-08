#!/bin/bash
# window swallow emulation for Niri
# (https://github.com/YaLTeR/niri/discussions/762)
# requires at least commit d5cbc35 / version 0.1.10
#
# this script shrinks the terminal into a column with the new window.
# bind it in your shell as an alias like "hide".
#
# example:
#
# 	niri-swal.sh mpv mpv video.mp4
# 	niri-swal.sh org.pwmt.zathura zathura document.pdf
#
# an app_id argument is required to ensure the right window is being swallowed.
# to get this argument, use `niri msg windows`.

set -e

TERM_ID="$(niri msg --json focused-window | jq -r .id)"
APP_ID="$1"
shift

{
	# if within 7 events, we don't see the window open, give up to avoid swallowing unexpectedly later
	APP_WIN_ID=$(
		# head -n 1 will wait for a second event before terminating
		# https://superuser.com/a/275962
		head -n 1 <(
			niri msg --json event-stream | jq --unbuffered --null-input --raw-output "range(7) as \$i | input | .WindowOpenedOrChanged | select(.) | select (.window.app_id == \"$APP_ID\") | .window.id"
		)
	)

	if [ -z "$APP_WIN_ID" ]; then
		exit 1
	fi

	niri msg action focus-window --id "$TERM_ID"
	niri msg action consume-or-expel-window-left --id "$APP_WIN_ID"
	niri msg action move-window-down
	niri msg action set-window-height --id "$TERM_ID" 0%
	niri msg action focus-window-up
} &

"$@"

niri msg action reset-window-height --id "$TERM_ID"
