#!/bin/sh

if command -v khal > /dev/null; then
	# list events from now till end of day, except all day events
	khal list \
		-df "" \
		-f "{cancelled}{title} {location} ({start-style} {to-style} {end-style})" \
		now eod \
		| grep -v "(→ - →)" \
		| head -n 2
fi
