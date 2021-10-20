#/bin/sh

# Set XDG directories
export XDG_CONFIG_HOME="$HOME"/.config
export XDG_CACHE_HOME="$HOME"/.cache
export XDG_DATA_HOME="$HOME"/.local/share

# Clean up home directory dotfiles

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
export MAILCAPS="$XDG_CONFIG_HOME"/tuir/mailcap
# terminfo
export TERMINFO="$XDG_DATA_HOME"/terminfo
export TERMINFO_DIRS="$XDG_DATA_HOME"/terminfo:/usr/share/terminfo

# Set editor
export EDITOR="nvim"

# Variables for passphrase2pgp
export REALNAME="dogeystamp"
export EMAIL="dogeystamp@disroot.org"
export KEYID="A3A5FA72F8E5E54FBEE425057225FE3592EFFA38"
