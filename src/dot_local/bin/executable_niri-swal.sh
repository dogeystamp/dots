#!/bin/bash
# window swallow emulation for Niri
# (https://github.com/YaLTeR/niri/discussions/762)
#
# - requires at least commit d5cbc35 / version 0.1.10
# - depends on `jq`, `socat`
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

if [ -z "$NIRI_SOCKET" ]; then
	# assume we're not running on niri, just run the thing
	"$@"
	exit
fi

TERM_DATA=$(niri msg --json focused-window)

TERM_ID="$(printf "%s" "$TERM_DATA" | jq -r .id)"
TERM_WORKSPACE_ID="$(printf "%s" "$TERM_DATA" | jq -r .workspace_id)"

APP_ID="$1"
shift

sock_printf() {
	printf $@ | socat - "$NIRI_SOCKET" > /dev/null
}

{
	# if within 30 events, we don't see the window open, give up to avoid swallowing unexpectedly later
	WIN_DATA=$(
		# without the bashism, this will wait for a second event before terminating
		# https://superuser.com/a/275962
		jq --null-input "input" <(
			niri msg --json event-stream | jq --unbuffered --null-input "range(30) as \$i | input | .WindowOpenedOrChanged | select(.) | select (.window.app_id == \"$APP_ID\")"
		)
	)

	APP_WIN_ID=$(printf "%s" "$WIN_DATA" | jq ".window.id")
	WORKSPACE_ID=$(printf "%s" "$WIN_DATA" | jq ".window.workspace_id")

	if [ -z "$APP_WIN_ID" ]; then
		exit 1
	fi

	# move the new window onto the terminal's workspace
	sock_printf '{"Action":{"MoveWindowToWorkspace":{"window_id":%s,"reference":{"Id":%s}}}}' "$APP_WIN_ID" "$TERM_WORKSPACE_ID"

	niri msg action focus-window --id "$TERM_ID"
	niri msg action consume-or-expel-window-left --id "$APP_WIN_ID"
	niri msg action move-window-down
	niri msg action set-window-height --id "$TERM_ID" 0%
	niri msg action focus-window-up

	# focus back onto the workspace the app spawned on
	sock_printf '{"Action":{"FocusWorkspace":{"reference":{"Id":%s}}}}' "$WORKSPACE_ID"
} &

set +e

"$@"
STATUS="$?"

set -e

niri msg action reset-window-height --id "$TERM_ID"

exit $STATUS
