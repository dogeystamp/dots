#!/bin/sh
# Backup to external disk (or remote) with Borg.

set -e

case "$1" in
  elements)
    export DISKNAME='elements'
	export BORG_REPO=/media/$DISKNAME/borg/main
    export BK_CORE=1
    export BK_STANDARD=1
    export BK_ARCHIVE=1
    export BK_SERVER=1
    export BK_LOWTIER=1
    ;;

  remote)
	export BORG_REPO="ssh://caupo/~/borg"
    export BK_CORE=1
    export BK_STANDARD=1
    export BK_ARCHIVE=1
    ;;
  *)
    printf "usage: %s [elements,remote]\n" "$0" > /dev/stderr
    exit 1
    ;;
esac

SCR_BORG_PATHS=""
SCR_BORG_TIERS=""

if [ -n "$BK_CORE" ]; then
  SCR_BORG_PATHS="$SCR_BORG_PATHS $HOME/core $HOME/.ssh"
  SCR_BORG_TIERS="$SCR_BORG_TIERS CORE"
fi
if [ -n "$BK_STANDARD" ]; then
  SCR_BORG_PATHS="$SCR_BORG_PATHS $HOME/med $HOME/proj $HOME/src $HOME/nt"
  SCR_BORG_TIERS="$SCR_BORG_TIERS STANDARD"
fi
if [ -n "$BK_ARCHIVE" ]; then
  SCR_BORG_PATHS="$SCR_BORG_PATHS $HOME/arc"
  SCR_BORG_TIERS="$SCR_BORG_TIERS ARCHIVE"
fi
if [ -n "$BK_LOWTIER" ]; then
  SCR_BORG_PATHS="$SCR_BORG_PATHS $HOME/thi"
  SCR_BORG_TIERS="$SCR_BORG_TIERS LOWTIER"
fi
if [ -n "$BK_SERVER" ]; then
  SCR_BORG_PATHS="$SCR_BORG_PATHS $HOME/sv"
  SCR_BORG_TIERS="$SCR_BORG_TIERS SERVER"
fi

info() {
  printf "\n%s %s\n\n" "$( date )" "$*" >&2
}

info "Preparing to perform backup for '$BORG_REPO';"
info ">>> tiers: $SCR_BORG_TIERS"
info ">>> paths: $SCR_BORG_PATHS"
sleep 5

borg create \
	--list \
	--filter AMCE \
	--progress \
	--stats \
	--show-rc \
	::'{hostname}-{now}' \
	$SCR_BORG_PATHS

info "Done backup. Remember to unmount disks."

