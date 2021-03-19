#!/bin/sh

setxkbmap -layout us,ca -variant multi -option 'grp:win_space_toggle, caps:swapescape'
xset r rate 300 50
mon-on
picom &
xwallpaper --center .config/wall.png
dunst &

while true; do
    xsetroot -name "$(date) $(acpi | cut -d',' -f2)"
	sleep 2
done &

exec dwm

