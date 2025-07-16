#!/bin/bash
# window swallow emulation for Niri
# (https://github.com/YaLTeR/niri/discussions/762)
#
# - tested on niri 25.05.1 (8ba57fc) as of 2025-06-22
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
	printf "$@" | socat - "$NIRI_SOCKET" # > /dev/stderr
}

err_printf() {
	true # no-op

	# printf "$@" > /dev/stderr
}

{
	# if within 30 events, we don't see the window open, give up to avoid swallowing unexpectedly later
	WIN_DATA=$(
		# without the bashism, this will wait for a second event before terminating
		# https://superuser.com/a/275962
		jq --null-input "input" <(
			niri msg --json event-stream | jq --unbuffered --null-input "range(30) as \$i | input | .WindowOpenedOrChanged | select(.) | select (.window.app_id == \"$APP_ID\")"
		)  2> /dev/null  || true
	)

	APP_WIN_ID=$(printf "%s" "$WIN_DATA" | jq ".window.id")
	WORKSPACE_ID=$(printf "%s" "$WIN_DATA" | jq ".window.workspace_id")

	if [ -z "$APP_WIN_ID" ]; then
		err_printf "\nfailed to get swallow window matching '%s'\n" "$APP_ID"
		exit 1
	fi

	err_printf "\ngot window %s (workspace %s)\n" "$APP_WIN_ID" "$WORKSPACE_ID"

	# save the currently focused monitor
	FOCUSED_OUTPUT=$(niri msg --json focused-output | jq -r .name)
	err_printf "\nFOCUSED_OUTPUT: %s\n" "$FOCUSED_OUTPUT"

	err_printf "\nseconds before window open: %s\n" "$SECONDS"
	if (( $SECONDS > 1 )); then
		# make the new window appear next to the terminal (if the terminal isn't focused).
		# this only triggers if the window took more than 1 second to appear,
		# because this focus makes Niri's viewport shift;
		# without this code, the viewport is not changed.
		# so we only want to do this if we have to.
		# the user usually doesn't have time to focus away from the terminal in 1 second.

		# focus on the terminal so the new window appears to it
		niri msg action focus-window --id "$TERM_ID"
		err_printf "focusing on win %s (TERM_ID)\n" "$TERM_ID"

		# move the window to the correct monitor
		niri msg action move-window-to-monitor --id "$APP_WIN_ID" "$TERM_OUTPUT"
		err_printf "\nmoved win %s (APP_WIN_ID) to monitor %s (TERM_OUTPUT)\n" "$APP_WIN_ID" "$TERM_OUTPUT"

		# move the new window onto a random workspace to make it forget its location
		niri msg action move-window-to-workspace --window-id "$APP_WIN_ID" --focus false 255
		err_printf "\nmoved win %s (APP_WIN_ID) to workspace 255\n" "$APP_WIN_ID"

		# move the new window onto the terminal's workspace
		sock_printf '{"Action":{"MoveWindowToWorkspace":{"window_id":%s,"reference":{"Id":%s},"focus":true}}}' "$APP_WIN_ID" "$TERM_WORKSPACE_ID"
		err_printf "\nmoved win %s (APP_WIN_ID) to workspace %s (TERM_WORKSPACE_ID)\n" "$APP_WIN_ID" "$TERM_WORKSPACE_ID"
	fi

	# consume the app into the terminal column
	niri msg action consume-or-expel-window-left --id "$APP_WIN_ID"
	niri msg action set-column-display tabbed
	niri msg action focus-window --id "$APP_WIN_ID"

	# focus back onto the workspace the app spawned on
	sock_printf '{"Action":{"FocusWorkspace":{"reference":{"Id":%s}}}}' "$WORKSPACE_ID"

	# focus back onto the monitor that was focused
	niri msg action focus-monitor "$FOCUSED_OUTPUT"
} &

set +e

"$@"
STATUS="$?"

set -e

# pass through command's status
exit $STATUS
