#!/bin/sh

if command -v khal > /dev/null; then
	khal list  -df "" -f "{cancelled}{title} {location} ({start-style} {to-style} {end-style})" --once --notstarted now 9h | head -n 1
fi
