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
		MINUTE="$(date +"%M" | tr -d '\n' | tail -c1)"
		if [ $MINUTE = 0 ] || [ $MINUTE = 5 ] ; then
			# periodically nag
			notify-send -a "TRACK" -r "$NOTIF1_ID" -u low "" "NO TRACKING" -t 6000
		fi
	fi

	SCHED="$(khal list -a Personal now 10m -f {title} -df "" | head -n 1)"
	if [ -n "$SCHED" ]; then
		notify-send -a "SCHED" -r "$NOTIF2_ID"  -u low "" "$SCHED"
	fi
	sleep 5
done
