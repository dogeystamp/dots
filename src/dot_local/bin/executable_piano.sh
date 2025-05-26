#!/bin/sh
# Script to set up the digital piano synth without a GUI.
#
# Requires an instrument sample pack, which can be obtained from:
# - https://freepats.zenvoid.org/Piano/acoustic-grand-piano.html
# - https://linuxsampler.org/instruments.html
# This script also requires manual PipeWire configuration using, for example, qpwgraph,
# to hook the MIDI input to LinuxSampler, and then LinuxSampler to your audio output.
# Once configured, save your PipeWire patchbay as "~/.config/piano_patch.qpwgraph".
#
# Depends on: linuxsampler, netcat, pipewire-jack, qpwgraph
#
# Examples:
#
# 	piano.sh ~/samples/maestro_concert_grand.gig
# 	piano.sh ~/samples/salamander.sfz
#
# The file extension is used to recognize the file format, so it is necessary that it is correct.

set -e

die() {
	echo "$@" > /dev/stderr
	exit 1
}

if [ -z "$INSTRUMENT_IDX" ]; then
	INSTRUMENT_IDX=0
fi

if [ -z "$INSTRUMENT_VOLUME" ]; then
	INSTRUMENT_VOLUME=0.15
fi

if [ -z "$PIANO_PATCH" ]; then
	PIANO_PATCH="$HOME"/.config/piano_patch.qpwgraph
fi
PIANO_PATCH=$(realpath "$PIANO_PATCH")

INSTRUMENT="$1"
INSTRUMENT=$(realpath "$INSTRUMENT")

if [ -z "$INSTRUMENT" ]; then
	die "No instrument sample pack provided. See script source for more information."
fi

case "$INSTRUMENT" in
	*.gig) FORMAT="gig" ;;
	*.sfz) FORMAT="sfz" ;;
	*.sf2) FORMAT="sf2" ;;
	*) die "Unknown format for instrument: $INSTRUMENT" ;;
esac

pw-jack linuxsampler &

cat << EOF | nc localhost 8888

SET ECHO 1

CREATE AUDIO_OUTPUT_DEVICE JACK
CREATE MIDI_INPUT_DEVICE ALSA
ADD CHANNEL
LOAD ENGINE $FORMAT 0
SET CHANNEL AUDIO_OUTPUT_DEVICE 0 0
SET CHANNEL MIDI_INPUT_DEVICE 0 0
LOAD INSTRUMENT '$INSTRUMENT' $INSTRUMENT_IDX 0
SET VOLUME $INSTRUMENT_VOLUME
GET CHANNEL INFO 0
QUIT

EOF

echo "Quit qpwgraph to gracefully stop piano.sh." > /dev/stderr
qpwgraph "$PIANO_PATCH"
echo "piano.sh stopping..." > /dev/stderr

# these processes love to linger around
killall -q ls-main
killall -q linuxsampler
