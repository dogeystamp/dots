#!/bin/sh
# Wrapper to view images in either X11 or Wayland.
# Requires: swayimg, nsxiv

if [ -n "$WAYLAND_DISPLAY" ]; then
	swayimg $@
else
	nsxiv $@
fi
