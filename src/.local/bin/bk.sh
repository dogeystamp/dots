#!/bin/sh

# Remote backup script
# Either push files to remote or receive full backup tarballs

while getopts ":pr" o; do
	case "${o}" in
		p) ACTION=PUSH ;;
		r) ACTION=RECV ;;
	esac
done

eval `ssh-agent`
ssh-add ~/.ssh/keys/lambda

if [ $ACTION = PUSH ]
then
	rsync -avzP \
		--chown=dogeystamp:sftpr \
		--exclude=med/mus \
		--exclude=med/gv \
		--exclude=sb-socket \
		--exclude=med/sb/cur \
		--exclude=dox/dow \
		--exclude=dox/rss \
		--exclude=dox/rem \
		--exclude=dox/proj \
		--exclude=dox/vms \
		--exclude=dox/mail/disroot \
		--exclude=med/pix/hdri \
		--exclude=med/memes/woof/quar \
		--exclude=BL_proxy \
		--exclude=a.out \
		--exclude=dlcache \
		--exclude=.synctex.gz \
		--exclude=.fls \
		--exclude=.fdb_latexmk \
		--exclude=.aux \
		~/med ~/dox ~/.xonotic dogeystamp@lambda:/mnt/disk/uv/
fi

if [ $ACTION = RECV ]
then
	rsync -avzP --append-verify \
		dogeystamp@lambda:/mnt/disk_b/ ~/arc/bk/
	rsync -avzP \
		dogeystamp@lambda:/mnt/disk/data/navidrome/mus/ ~/med/mus
fi

kill $SSH_AGENT_PID
