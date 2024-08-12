#!/bin/sh

# Dunst notification sound script.

if [ "$DUNST_APP_NAME" = "soundboard" ]; then
	exit
fi
if [ "$DUNST_APP_NAME" = "prod" ]; then
	exit
fi

paplay ~/.local/bin/deskutils/notif.mp3
