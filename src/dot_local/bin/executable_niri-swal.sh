#!/bin/bash
# window swallow emulation for Niri
# (https://github.com/YaLTeR/niri/discussions/762)
#
# - works best with commit fd3b1f2b or later
# - depends on `jq`, `socat`
#
# this script consumes the app into the terminal's column as a new tab.
# you should bind mpv, swayimg, zathura, etc. to aliases that call this script.
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
TERM_OUTPUT="$(niri msg --json workspaces | jq -r ".[] | select(.id == $TERM_WORKSPACE_ID) | .output")"

APP_ID="$1"
shift

sock_printf() {
	printf $@ | socat - "$NIRI_SOCKET" > /dev/tty
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

	# save the currently focused monitor
	FOCUSED_OUTPUT=$(niri msg --json focused-output | jq -r .name)

	# make the new window appear next to the terminal
	niri msg action focus-window --id "$TERM_ID"

	# move the window to the correct monitor
	niri msg action move-window-to-monitor --id "$APP_WIN_ID" "$TERM_OUTPUT"

	# move the new window onto the terminal's workspace
	sock_printf '{"Action":{"MoveWindowToWorkspace":{"window_id":%s,"reference":{"Id":%s},"focus":true}}}' "$APP_WIN_ID" "$TERM_WORKSPACE_ID"

	niri msg action consume-or-expel-window-left --id "$APP_WIN_ID"
	niri msg action set-column-display tabbed
	niri msg action focus-window --id "$APP_WIN_ID"

	# focus back onto the workspace the app spawned on
	sock_printf '{"Action":{"FocusWorkspace":{"reference":{"Id":%s}}}}' "$WORKSPACE_ID"

	# focus back onto the monitor that was focused
	niri msg action focus-monitor "$FOCUSED_OUTPUT"
	echo "$FOCUSED_OUTPUT"
} &

set +e

"$@"
STATUS="$?"

set -e

exit $STATUS
