#!/bin/sh

# Screenshot and save to disk.

sleep 0.1 && scrot -fs '/tmp/%F_%T_$wx$h.png' -e 'cp $f ~/med/screen/latest.png && mv $f ~/med/screen/'
