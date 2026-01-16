#!/bin/sh
# visual reminder of time-tracking status

if ! command -v timew > /dev/null; then
	printf "No timew found" > /dev/stderr
	exit 1
fi

if ! command -v khal > /dev/null; then
	printf "No khal found" > /dev/stderr
	exit 1
fi

NOTIF1_ID=$(notify-send -a "TRACK" -p STARTING... -u low -t 1)
NOTIF2_ID=$(notify-send -a "SCHED" -p STARTING... -u low -t 1)
while true; do
	if [ "$(timew get dom.active)" = "1" ]; then
		notify-send -a "TRACK" -r "$NOTIF1_ID" -u low "" "$(timew)"
	else
		SCHED="$(khal list -a Timeblock now 1m -f {title} -df "" | head -n 1)"
		if [ -n "$SCHED" ]; then
			# notify-send -a "SCHED" -r "$NOTIF2_ID"  -u low "" "$SCHED"
			MINUTE="$(date +"%M" | tr -d '\n' | tail -c1)"
			if [ $MINUTE = 0 ] || [ $MINUTE = 5 ] ; then
				# if there is a timeblock event, and no time tracking is happening, nag
				notify-send -a "TRACK" -r "$NOTIF1_ID" "" "No tracking during timeblock" -t 6000
			fi
		fi
	fi

	sleep 5
done
