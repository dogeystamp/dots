#!/bin/sh
# Categorize files in the quarantine directory

# read -n 1 isn't POSIX-compliant so we implement something
# https://unix.stackexchange.com/questions/464930/can-i-read-a-single-character-from-stdin-in-posix-shell
readc() {
	# return a single character from input

	# if tty
	if [ -t 0 ]; then
		# save settings
		saved_settings="$(stty -g)"
		# make it so we get the character even if no enter press
		stty -icanon
	fi

	dd bs=1 count=1 2>/dev/null

	if [ -t 0 ]; then
		# restore settings
		stty "$saved_settings"
	fi
}

view() {
	mpv --no-resume-playback "$1"
}

dirsel() {
	find ~/med/memes/ ~/med/rw/ -type d | \
		fzf --filepath-word --query "$1" --header "Select directory" | \
		sed 's:/*$::'
}

namesel() {
	if [ -z "$1" ]; then
		return 1
	fi
	ls "$1" | fzf -x --filepath-word --print-query --query "$2" --header "Select filename" | head -n 1
}

confirm() {
	DESTPATH="$1"
	FILE="$2"
	if [ -e "$DESTPATH" ]; then
		printf "'%s' already exists.\n" "$DESTPATH"
		return 1
	else
		mv -n "$FILE" "$DESTPATH"
		return 0
	fi
}

PREVDIR=""
PREVNAME=""
find ~/quar \
	-maxdepth 1 \
	-type f \
	-not -path '*/trash/*' \
	\( \
	-name '*.mov' -o \
	-name '*.MOV' -o \
	-name '*.mp4' -o \
	-name '*.jpg' -o \
	-name '*.png' -o \
	-name '*.jpeg' -o \
	-name '*.webp' -o \
	-name '*.gif' \
	\) | \
while read -r FILE; do
	clear
	view "$FILE"
	EXT="${FILE##*.}"
	DIR="$(dirsel "$PREVDIR")"
	NAME="$(namesel "$DIR" "$PREVNAME")"
	PREVDIR=""
	PREVNAME=""
	while true; do
		clear
		printf "\n\n%s\n" "$FILE"
		DESTPATH="$DIR"/"$NAME"."$EXT"
		printf "send to: %s\n" "$DESTPATH"
		printf "\nh view again, j set directory, k set name, l confirm, L confirm and preserve information\n q exit, s skip, d move to trash\n"
		printf "\n> "
		ANS="$(readc </dev/tty)"
		case "$ANS" in
			q ) exit;;
			h ) view "$FILE";;
			j ) DIR="$(dirsel "$DIR")";;
			k ) NAME="$(namesel "$DIR" "$NAME")";;
			l ) confirm "$DESTPATH" "$FILE" && break;;
			L ) if confirm "$DESTPATH" "$FILE"; then
				PREVDIR="$DIR"
				PREVNAME="$NAME"
				break
			fi;;
			s ) break;;
			d ) mv "$FILE" ~/quar/trash/; break;;
			* )
				printf "\nInvalid input! Press enter to continue\n";
				read </dev/tty;
				;;
		esac
	done
done
