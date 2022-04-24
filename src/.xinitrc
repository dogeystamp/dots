#!/bin/sh

setxkbmap -layout us,ca -variant multi -option 'grp:win_space_toggle, caps:swapescape'
xset r rate 300 50
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
	xsetroot -name " $(date +'%H:%M:%S %a %b %d') // $(acpi | cut -f4 -d " ") "
	sleep 2
done &

dwm
