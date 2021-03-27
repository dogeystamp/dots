#!/bin/sh

setxkbmap -layout us,ca -variant multi -option 'grp:win_space_toggle, caps:swapescape'
xset r rate 300 50
mon-on
picom &
xwallpaper --center .config/wall.png
xautolock -time 12 -locker "systemctl suspend" -detectsleep &
xss-lock -- slock &
dunst &

while true; do
    xsetroot -name "$(mpc -f %title% | head -n 1) $(mpc status | awk '/^\[playing\]/ { sub(/\/.+/,"",$4); print $3 }') | $(date) $(acpi | cut -d',' -f2)"
	sleep 2
done &

startdwm
