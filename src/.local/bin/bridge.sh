#!/bin/sh

# PulseAudio script to categorise audio streams
#
# - playing music while recording a call
# - piping sound files into a call via virtual mic
#
# Use the -b switch for bridging
# - connect calls from different applications



# Important settings

# Your real mic (pactl list short sources)
mic="alsa_input.usb-C-Media_Electronics_Inc._USB_Audio_Device-00.mono-fallback"

# Output sound to this sink (pactl list short sinks)
out="alsa_output.usb-C-Media_Electronics_Inc._USB_Audio_Device-00.analog-stereo"



# Naming settings

# Virtual mic for both voice and media
virt_mic="virtual_mic"
virt_mic_desc="Virtual\ mic"

# Input for media to pipe to call
media_in="media_in"
media_in_desc="Media\ input"

# Virtual mic for call
c1_in="c1_in"
c1_in_desc="Call\ input"

# Output of call
c1_out="c1_out"
c1_out_desc="Call\ output"

# Virtual mic for bridged call
c2_in="c2_in"
c2_in_desc="C2\ input"

# Output of bridged call
c2_out="c2_out"
c2_out_desc="C2\ output"



MODE="normal"
while getopts "b" o; do
	case "${o}" in
		b) MODE="bridge" ;;
	esac
done

# Set up call input/output
# Create sinks
pactl load-module module-null-sink sink_name="$c1_out" sink_properties=device.description="'$c1_out_desc'"
pactl load-module module-null-sink sink_name="$c1_in" sink_properties=device.description="'$c1_in_desc'"
# Output to real speakers
pactl load-module module-loopback source="$c1_out".monitor sink="$out"

# Set up media input
# Create sink
pactl load-module module-null-sink sink_name="$media_in" sink_properties=device.description="'$media_in_desc'"
# Output to real speakers
pactl load-module module-loopback source="$media_in".monitor sink="$out"

# Set up virtual mic
# Create sink
pactl load-module module-null-sink sink_name="$virt_mic" sink_properties=device.description="'$virt_mic_desc'"
# Loop in real mic
pactl load-module module-loopback source="$mic" sink="$virt_mic"
# Loop in media input
pactl load-module module-loopback source="$media_in".monitor sink="$virt_mic"
# Output to call input
pactl load-module module-loopback source="$virt_mic".monitor sink="$c1_in"

# Bridging
if [ $MODE = "bridge" ]; then
	# Create bridged call input/output sinks
	pactl load-module module-null-sink sink_name="$c2_out" sink_properties=device.description="'$c2_out_desc'"
	pactl load-module module-null-sink sink_name="$c2_in" sink_properties=device.description="'$c2_in_desc'"
	# Loop in virtual mic
	pactl load-module module-loopback source="$virt_mic".monitor sink="$c2_in"
	# Output to real speakers
	pactl load-module module-loopback source="$c2_out".monitor sink="$out"
	# Connect calls into each other
	pactl load-module module-loopback source="$c1_out".monitor sink="$c2_in"
	pactl load-module module-loopback source="$c2_out".monitor sink="$c1_in"
fi
