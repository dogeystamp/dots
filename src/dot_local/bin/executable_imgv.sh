#!/bin/sh
# Wrapper to view images in either X11 or Wayland.
# Requires: swayimg, nsxiv

if [ -n "$WAYLAND_DISPLAY" ]; then
	exec swayimg "$@"
else
	exec nsxiv "$@"
fi
