#!/bin/sh
# ping until successful, then alert

while true; do
	if ping -c 1 $1; then
		echo Ping successful
		notify-send -a "ping-up" "Ping is successful"
		figlet Ping successful
		tput bel
		break
	else
		sleep 5
	fi
done
