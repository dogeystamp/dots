#!/bin/sh

setxkbmap -layout us,ca -variant multi -option 'grp:win_space_toggle, caps:swapescape'
xset r rate 300 50
mon-on
picom --experimental-backends --backend glx &
xwallpaper --center .config/wall.png
wal --theme sexy-phrak1 -b 080808
conky
xautolock -time 12 -locker "systemctl suspend" -detectsleep -notify 5 -notifier "notify-send Locking" &
xss-lock -- slock &
#dunst crashes X for some reason on my device so I put it in screen to prevent that
screen -dm dunst notifs

dwm
