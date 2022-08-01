#!/bin/sh

# Suspend the device.

if [ $(which systemctl 2> /dev/null) ]; then
	systemctl suspend
else
	doas /bin/loginctl suspend
fi
