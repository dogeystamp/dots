#!/bin/sh

# Screenshot to clipboard, and leave a copy at ~/med/screen/latest.png

sleep 0.1 && scrot -fs '/tmp/%F_%T_$wx$h.png' -e 'cp $f ~/med/screen/latest.png && xclip -selection clipboard -target image/png -i $f'
