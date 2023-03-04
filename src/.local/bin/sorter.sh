#!/bin/sh
# Categorize files in the quarantine directory

view() {
	mpv --no-resume-playback $@
}

dirsel() {
	FILEPATH=$(
	find ~/med/memes/ ~/med/rw/ -type d |
		fzf --no-sort --query "$1" --header "Select directory" | \
		(
			read -r QUERY
			read -r RES
			if [ -z "$(printf "%s" "$RES" | tr -d '\n')" ]; then
				printf "%s" "$QUERY"
			else
				printf "%s" "$RES"
			fi
		)
	)
	printf "%s" "$FILEPATH" | sed 's:/*$::'
}

namesel() {
	ls "$1" | fzf --print-query --query "$2" --header "Select filename"
}

find ~/quar -name '*.mov' -or -name '*.MOV' -or -name '*.mp4' -or -name '*.jpg' -or -name '*.png' -or -name '*.jpeg' | \
while read -r FILE; do
	view "$FILE"
	EXT="${FILE##*.}"
	DIR="$(dirsel "")"
	NAME="$(namesel "$DIR" "")"
	while true; do
		clear
		printf "%s\n" "$FILE"
		DESTPATH="$DIR"/"$NAME"."$EXT"
		printf "send to: %s\n" "$DESTPATH"
		printf "\nh view again, j set directory, k set name, l confirm, q exit, s skip\nd move to trash\n"
		printf "\n> "
		read -n 1 ANS < /dev/tty
		case "$ANS" in
			q ) exit;;
			h ) view "$FILE";;
			j ) DIR="$(dirsel "$DIR")";;
			k ) NAME="$(namesel "$DIR" "$NAME")";;
			l )
				if [ -e "$DESTPATH" ]; then
					printf "'%s' already exists.\n" "$DESTPATH"
				else
					mv -n "$FILE" "$DESTPATH"
					break
				fi
				;;
			s ) break;;
			d ) mv "$FILE" ~/quar/trash/; break;;
		esac
	done
done
