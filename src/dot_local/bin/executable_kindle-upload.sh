#!/bin/sh
# Upload schedule to Kindle.
# Run as root.

KINDLE_USER=dogeystamp

mount -o uid=$KINDLE_USER /dev/disk/by-uuid/5C78-760A /mnt/ \
	&& run0 -u $KINDLE_USER -- cp -f ~dogeystamp/.local/share/schedule.pdf /mnt/documents/schedule.pdf \
	&& umount /mnt \
	&& sleep 1 \
	&& udisksctl power-off -b /dev/disk/by-uuid/5C78-760A
