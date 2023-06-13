#!/bin/sh

# Set XDG directories
export XDG_CONFIG_HOME="$HOME"/.config
export XDG_CACHE_HOME="$HOME"/.cache
export XDG_DATA_HOME="$HOME"/.local/share
export XDG_DOWNLOAD_DIR="$HOME"/quar/

# Clean up home directory dotfiles

# xinit
export XINITRC="$XDG_CONFIG_HOME"/xinitrc
# XAuthority
export XAUTHORITY="$XDG_RUNTIME_DIR"/Xauthority
# GTK2
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
# zsh
export ZDOTDIR="$HOME"/.config/zsh
export HISTFILE="$XDG_DATA_HOME"/zsh/history
# less
export LESSHISTFILE=-
# gpg
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
# pass
export PASSWORD_STORE_DIR="$XDG_DATA_HOME"/pass
# tuir
export MAILCAPS="$XDG_CONFIG_HOME"/mailcap
# terminfo
export TERMINFO="$XDG_DATA_HOME"/terminfo
export TERMINFO_DIRS="$XDG_DATA_HOME"/terminfo:/usr/share/terminfo
# go
export GOPATH="$XDG_DATA_HOME"/go
# npm
export npm_config_userconfig=$XDG_CONFIG_HOME/npm/config
export npm_config_cache=$XDG_CACHE_HOME/npm
export npm_config_prefix=$XDG_DATA_HOME/npm
# xpilot
export XPILOTRC=$XDG_CONFIG_HOME/xpilotrc

# minrss scripts
export MRSS_DIR="$HOME/dox/rss"

# reminder script
export REM_FILE="$HOME/dox/not/rem"

# Set default programs
export EDITOR="nvim"
export BROWSER="qutebrowser"
# man pager
export MANPAGER='nvim +Man!'
export MANWIDTH=165

# Soundboard
export SB_DIR="$HOME"/med/sb
export SXHKD_SHELL='/bin/sh'

# Variables for passphrase2pgp
export REALNAME="dogeystamp"
export EMAIL="dogeystamp@disroot.org"
export KEYID="A3A5FA72F8E5E54FBEE425057225FE3592EFFA38"

export KEEPASSDB="$HOME"/dox/sec/pass.kdbx
# Identity (see ~/.local/bin/identity.sh)
if [ -r "$XDG_CONFIG_HOME"/identity ]; then
	. "$XDG_CONFIG_HOME"/identity
fi

# Profile to enable/disable features on certain devices
if [ ! -f "$XDG_CONFIG_HOME"/dot_profile ]; then
	export SYSTEM_PROFILE="SLIM"
else 
	. "$XDG_CONFIG_HOME"/dot_profile
fi

. .config/bashrc
