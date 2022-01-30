#!/bin/sh

# Remote backup script

rsync -avzP \
	--exclude=mus \
	--exclude=gv \
	--exclude=dow \
	--exclude=rss \
	--exclude=rem \
	--exclude=proj \
	--exclude=vms \
	--exclude=pix/hdri \
	~/med ~/dox dogeystamp@patria:/mnt/disk/uv/
