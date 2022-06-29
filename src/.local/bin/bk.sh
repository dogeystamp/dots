#!/bin/sh

# Remote backup script
# Either push files to remote or receive full backup tarballs

while getopts ":pr" o; do
	case "${o}" in
		p) ACTION=PUSH ;;
		r) ACTION=RECV ;;
	esac
done

if [ $ACTION = PUSH ]
then
	rsync -avzP \
		--chown=dogeystamp:sftpr \
		--exclude=med/mus \
		--exclude=med/gv \
		--exclude=dox/dow \
		--exclude=dox/rss \
		--exclude=dox/rem \
		--exclude=dox/proj \
		--exclude=dox/vms \
		--exclude=med/pix/hdri \
		--exclude=med/memes/woof/quar \
		--exclude=BL_proxy \
		--exclude=a.out \
		~/med ~/dox dogeystamp@lambda:/mnt/disk/uv/
fi

if [ $ACTION = RECV ]
then
	rsync -avzP --append-verify \
		dogeystamp@lambda:/mnt/disk_b/ ~/arc/bk/
	rsync -avzP \
		dogeystamp@lambda:/mnt/disk/data/navidrome/mus/ ~/med/mus
fi

