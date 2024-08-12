#!/bin/sh

# Shut down the device.

if [ $(which systemctl 2> /dev/null) ]; then
	shutdown now
else
	doas /bin/loginctl poweroff
fi
