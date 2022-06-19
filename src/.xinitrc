#!/bin/sh

mon-on
#picom --experimental-backends --backend glx &
xwallpaper --center .config/wall.png
# Host specific wallpapers
wallpaper
xss-lock -- slock &
dunst &
xrdb .Xresources

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
	BAT="$(acpi | cut -f4 -d " " | tr -d ',')"

	xsetroot -name " $DATE // $TEMP, $BAT "
	sleep 2
done &

dwm
