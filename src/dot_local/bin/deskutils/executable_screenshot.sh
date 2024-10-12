#!/bin/sh

# Screenshot to clipboard, and leave a copy at ~/med/screen/latest.png

rm ~/med/screen/latest.jpg
scrot --freeze --select -l style=dash "$HOME/med/screen/latest.jpg" -e 'xclip -selection clipboard -target image/jpeg -i $f'
