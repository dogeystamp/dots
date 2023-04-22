#!/bin/sh

mon-on

if [ $SYSTEM_PROFILE = "MINIMAL" ]; then
	dwm
	exit
fi

if [ $SYSTEM_PROFILE = "DEFAULT" ]; then
	picom &
fi
xwallpaper --center .config/wall.png
# Host specific wallpapers
wallpaper
xss-lock -- slock &
dunst &
xrdb .Xresources
# gentoo-pipewire-launcher &

# DBus
export NO_AT_BRIDGE=1
eval $(dbus-launch --sh-syntax)
export DBUS_SESSION_BUS_ADDRESS
export DBUS_SESSION_BUS_PID
export DBUS_SESSION_BUS_WINDOWID

# IME
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

while true; do
	DATE=$(date +'%H:%M:%S %a %b %d')
	TEMP="$(($(cat /sys/class/thermal/thermal_zone0/temp) / 1000))C"
	BAT="$(acpi -b | head -n 1 | awk -F'[,:]' '{print $3}' | tr -d '[:space:]')"
	KEY="$(xkblayout-state print '%s')"

	xsetroot -name " $DATE // $TEMP, $BAT // $KEY"
	sleep 1
done &

dwm
