#!/bin/sh

# Screenshot to clipboard, and leave a copy at ~/med/screen/latest.png

rm ~/med/screen/latest.png
sleep 0.1 && scrot -fs "$HOME/med/screen/latest.png" -e 'xclip -selection clipboard -target image/png -i $f'
