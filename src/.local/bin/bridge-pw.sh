#!/bin/sh

# bridge.sh for pipewire
# use pulsemixer to set the default playback of mpv to the soundboard
# use a patchbay to connect anything else

# pipewire null sinks are garbage performance
#pw-cli create-node adapter factory.name=support.null-audio-sink media.class="Audio/Sink" object.linger=1 node.name="Soundboard" monitor.channel-volumes=1

# play back sounds through this device
MONITOR="USB Audio Device"

pactl load-module module-null-sink sink_name="soundboard" sink_properties=device.description="Soundboard"
pactl set-sink-volume soundboard 0.5
pactl load-module module-null-sink sink_name="virtual_mic" sink_properties=device.description="Virtual-mic"

pw-link soundboard:monitor_FR "$MONITOR":playback_FR
pw-link soundboard:monitor_FL "$MONITOR":playback_FL
pw-link soundboard:monitor_FR virtual_mic:playback_FR
pw-link soundboard:monitor_FL virtual_mic:playback_FL
