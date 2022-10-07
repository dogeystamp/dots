#!/bin/sh

# Dunst notification sound script.

if [ $DUNST_URGENCY = "LOW" ]; then
	exit
fi

if pactl list short sinks | grep -q virtual_mic; then
	mpv ~/.local/bin/deskutils/notif.wav --audio-device=pulse/c1_out
else
	mpv ~/.local/bin/deskutils/notif.wav
fi
