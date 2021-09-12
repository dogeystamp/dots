#!/bin/sh

setxkbmap -layout us,ca -variant multi -option 'grp:win_space_toggle, caps:swapescape'
xset r rate 300 50
mon-on
picom --experimental-backends --backend glx &
#xwallpaper --center .config/wall.png
xwallpaper --output DP-2-1 --center med/pix/dow/ml.png --output DP-1 --center med/pix/dow/mr.png --output eDP-1 --center med/pix/dow/m.png
xss-lock -- slock &
#dunst crashes X for some reason on my device so I put it in screen to prevent that
screen -dm dunst notifs
xrdb .Xresources

while true; do
	xsetroot -name "$(date +'%H:%M:%S %a %b %d')"
	sleep 2
done &

dwm
