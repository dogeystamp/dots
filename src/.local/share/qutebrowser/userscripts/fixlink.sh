#!/bin/sh
# libredirect but scuffed and a qutebrowser userscript
#
# bind something like this in config.py
#
# 	config.bind(",fl", "hint links userscript fixlink.sh")
# 	config.bind(",fL", "hint links userscript fixlink.sh -t")
#

REDDIT="lr.mint.lgbt"
TWITTER="nitter.net"
# genius lyrics
GENIUS="sing.whatever.social"
YOUTUBE="yewtu.be"

LINK="$(printf "%s" "$QUTE_URL" | sed \
	-e "s/www.reddit.com/$REDDIT/g" \
	-e "s/twitter.com/$TWITTER/g" \
	-e "s/genius.com/$GENIUS/g" \
	-e "s/youtube.com/$YOUTUBE/g")"

echo "open $1 $LINK" >> "$QUTE_FIFO"
