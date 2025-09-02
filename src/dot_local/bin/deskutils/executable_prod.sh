#!/bin/sh
# visual reminder of time-tracking status

while true; do
	notify-send -a "prod" -r 13371234 "$(timew)"
	sleep 5
done
