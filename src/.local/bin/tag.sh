#!/bin/sh
TMPFILE="$(mktemp)"
nvim "$TMPFILE"
cat "$TMPFILE" | while read line; do
	link="$(echo $line | awk -F";" '{print $1}')"
	artist="$(echo $line | awk -F";" '{print $2}')"
	alb="$(echo $line | awk -F";" '{print $3}')"
	trk="$(echo $line | awk -F";" '{print $4}')"
	file="$artist-$alb-$trk"
	yt-dlp "$link" -x --audio-format mp3 --no-playlist -o "$file.%(ext)s"
	mid3v2 -a "$artist" "$file"*
	mid3v2 -A "$alb" "$file"*
	if [ -z "$trk" ]; then
		mid3v2 -t "$alb" "$file"*
	else
		mid3v2 -t "$trk" "$file"*
	fi
done
