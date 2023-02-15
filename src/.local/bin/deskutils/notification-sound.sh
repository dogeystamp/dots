#!/bin/sh

# Dunst notification sound script.

if [ "$DUNST_APP_NAME" = "soundboard" ]; then
	exit
fi
if [ "$DUNST_APP_NAME" = "prod" ]; then
	exit
fi

if pactl list short sinks | grep -q virtual_mic; then
	mpv ~/.local/bin/deskutils/notif.wav --audio-device=pulse/alsa_output.usb-C-Media_Electronics_Inc._USB_Audio_Device-00.analog-stereo
else
	mpv ~/.local/bin/deskutils/notif.wav
fi
