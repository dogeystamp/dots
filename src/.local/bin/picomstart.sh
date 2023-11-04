#!/bin/sh
# misc opts so i don't have to use absolute path in picom config

picom --window-shader-fg-rule "$HOME/.config/picom/shaders/transparency.glsl:class_g = 'qutebrowser'"
