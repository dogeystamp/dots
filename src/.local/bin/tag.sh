#!/bin/sh
TMPFILE="$(mktemp)"
nvim "$TMPFILE"
cat "$TMPFILE" | while read line; do
	link="$(echo $line | awk -F";" '{print $1}')"
	artist="$(echo $line | awk -F";" '{print $2}')"
	alb="$(echo $line | awk -F";" '{print $3}')"
	file="$artist-$alb"
	yt-dlp "$link" -x --audio-format mp3 --no-playlist -o "$file.%(ext)s"
	mid3v2 -a "$artist" "$file"*
	mid3v2 -A "$alb" "$file"*
	mid3v2 -t "$alb" "$file"*
done
