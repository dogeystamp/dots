#!/bin/sh
# visual reminder of watson status

while true; do
	notify-send -a "prod" -r 13371234 "$(watson status)"
	sleep 5
done
