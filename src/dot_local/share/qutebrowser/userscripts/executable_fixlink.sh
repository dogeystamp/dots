#!/bin/sh
# libredirect but scuffed and a qutebrowser userscript
#
# bind something like this in config.py
#
# 	config.bind(",fl", "hint links userscript fixlink.sh")
# 	config.bind(",fL", "hint links userscript fixlink.sh -t")
#

REDDIT="old.reddit.com"
TWITTER="nitter.net"
# genius lyrics
GENIUS="dm.vern.cc"
# fandom the wiki
FANDOM="breezewiki.com"
YOUTUBE="yewtu.be"
MEDIUM="libmedium.batsense.net"
QUORA="quetre.frontendfriendly.xyz"
OVERFLOW="ao.owo.si"

LINK="$(printf "%s" "$QUTE_URL" | sed \
	-e "s/www.reddit.com/$REDDIT/g" \
	-e "s/old.reddit.com/$REDDIT/g" \
	-e "s/twitter.com/$TWITTER/g" \
	-e "s/genius.com/$GENIUS/g" \
	-e "s/fandom.com/$FANDOM/g" \
	-e "s/medium.com/$MEDIUM/g" \
	-e "s/www.quora.com/$QUORA/g" \
	-e "s/stackoverflow.com/$OVERFLOW/g" \
	-e "s/m.youtube.com/$YOUTUBE/g" \
	-e "s/youtube.com/$YOUTUBE/g")"

echo "open $1 $LINK" >> "$QUTE_FIFO"
