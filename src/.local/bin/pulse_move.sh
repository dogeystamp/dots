#!/bin/sh
# pulse_move.sh [binary name] [sink name]
#
# Use pactl list short sinks to find sink names.
# Will move all streams from a certain binary to the sink.


SINK_ID=$(pactl -f json list short sinks |
	jq -r ".[] | select(.name == \"$2\") | .index")

pactl -f json list clients |
	jq -r ".[] | select(.properties.\"application.process.binary\" == \"$1\") | .index" |
while read -r clientindex; do
	pactl -f json list short sink-inputs |
		jq -r ".[] | select(.client == \"$clientindex\") | .index"
done |
while read -r inputindex; do
	pacmd move-sink-input $inputindex $SINK_ID
done
