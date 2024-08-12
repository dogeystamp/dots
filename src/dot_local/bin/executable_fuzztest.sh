#!/bin/sh
# cobbled together testing script for competitive programming

set -e

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
	echo "usage: fuzztest.sh [test generator] [known-good] [to-test]"
	echo
	echo "test generator: prints a random test case to stdout"
	echo "known-good: reads from stdin, prints to stdout"
	echo "to-test: behaviour will be compared to known-good"
	echo
	echo "to use python programs here, add a python shebang and chmod +x"
	exit
fi

if [ -z "$FUZZDIR" ]; then
	FUZZDIR=~/.cache/fuzztester
fi
mkdir -p "$FUZZDIR"

while true; do
	$1 > "$FUZZDIR"/input
	wc -c "$FUZZDIR"/input
	cat "$FUZZDIR"/input | $3 > "$FUZZDIR"/faulty
	cat "$FUZZDIR"/input | $2 > "$FUZZDIR"/good

	RES="$(diff "$FUZZDIR"/faulty "$FUZZDIR"/good || true)"
	if [ ! -z "$RES" ]; then
		printf "\n\n\n-----------\n"
		echo failed test case detected!
		echo
		echo the known-good and to-test programs differed in output.
		echo
		echo stdin: "$FUZZDIR"/input
		echo faulty output: "$FUZZDIR"/faulty
		echo good output: "$FUZZDIR"/good
		break
	else
		echo good
	fi
done
