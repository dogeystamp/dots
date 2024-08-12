#!/bin/sh

# Reboot the device.

if [ $(which systemctl 2> /dev/null) ]; then
	reboot
else
	doas /bin/loginctl reboot
fi
