#!/bin/sh

# Screenshot and save to disk.

rm ~/med/screen/latest.png
sleep 0.1 && scrot -fs "$HOME/med/screen/latest.png" -e "cp ~/med/screen/latest.png ~/quar/screenshot-$(date +%s).png"
