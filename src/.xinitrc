#!/bin/sh

setxkbmap -layout us,ca -variant multi -option 'grp:win_space_toggle, caps:swapescape'
xset r rate 300 50
mon-on
picom --experimental-backends --backend glx &
xwallpaper --center .config/wall.png
# Host specific wallpapers
wallpaper
xss-lock -- slock &
dunst &
xrdb .Xresources

while true; do
	xsetroot -name "$(date +'%H:%M:%S %a %b %d')"
	sleep 2
done &

dwm
