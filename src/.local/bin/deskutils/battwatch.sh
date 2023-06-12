#!/bin/sh
# i didn't *really* feel like having a cronjob for this so

while true; do
	BAT="$(acpi -b | head -n 1 | awk -F'[,:]' '{print $3}' | tr -d '[:space:]%')"
	if [ "$BAT" -lt "10" ]; then
		notify-send -u critical -a battery "currently at $BAT%"
	elif [ "$BAT" -lt "20" ]; then
		notify-send -a battery "currently at $BAT%"
	fi
	sleep 240
done
