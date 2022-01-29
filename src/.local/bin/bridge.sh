#!/bin/sh

# Awful script I made to bridge calls from two services while also piping in audio

# Your real mic (pactl list short sources)
mic="alsa_input.usb-C-Media_Electronics_Inc._USB_Audio_Device-00.mono-fallback"

# Output sound to this sink (pactl list short sinks)
out="alsa_output.usb-C-Media_Electronics_Inc._USB_Audio_Device-00.analog-stereo"

# Name of the virtual mic output (combined mic and shared media)
virt_mic="virtual_mic"
virt_mic_desc="Virtual\ mic"

# Name of the media input sink
media_in="media_in"
media_in_desc="Media\ input"

# Name of the sink whose monitor will be used as the mic for the first call
c1_in="c1_in"
c1_in_desc="C1\ input"

# Name of the sink where the first call will be output
c1_out="c1_out"
c1_out_desc="C1\ output"

# Name of the sink whose monitor will be used as the mic for the second call
c2_in="c2_in"
c2_in_desc="C2\ input"

# Name of the sink where the second call will be output
c2_out="c2_out"
c2_out_desc="C2\ output"

# Create all the sinks

pactl load-module module-null-sink sink_name="$media_in" sink_properties=device.description="'$media_in_desc'"
pactl load-module module-null-sink sink_name="$virt_mic" sink_properties=device.description="'$virt_mic_desc'"
pactl load-module module-null-sink sink_name="$c1_out" sink_properties=device.description="'$c1_out_desc'"
pactl load-module module-null-sink sink_name="$c1_in" sink_properties=device.description="'$c1_in_desc'"
pactl load-module module-null-sink sink_name="$c2_out" sink_properties=device.description="'$c2_out_desc'"
pactl load-module module-null-sink sink_name="$c2_in" sink_properties=device.description="'$c2_in_desc'"

# Make connections between all sinks

# Loop back real mic to the virtual mic
pactl load-module module-loopback source="$mic" sink="$virt_mic"

# Loop back media input to virtual mic
pactl load-module module-loopback source="$media_in".monitor sink="$virt_mic"
# Loop back media input to regular audio output
pactl load-module module-loopback source="$media_in".monitor sink="$out"

# Loop combined output to both calls' inputs
pactl load-module module-loopback source="$virt_mic".monitor sink="$c1_in"
pactl load-module module-loopback source="$virt_mic".monitor sink="$c2_in"

# Loop the calls' outputs to each other's inputs and also local output
pactl load-module module-loopback source="$c1_out".monitor sink="$out"
pactl load-module module-loopback source="$c1_out".monitor sink="$c2_in"
pactl load-module module-loopback source="$c2_out".monitor sink="$out"
pactl load-module module-loopback source="$c2_out".monitor sink="$c1_in"
