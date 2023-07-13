#!/bin/sh
# wrapper over tmsu for easy tagging
#
# takes in file paths via stdin to tag
# pipe in `tmsu untagged` to tag untagged files

set -e

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
	mpv --no-resume-playback --loop "$1"
}

export TMSU_ARGS="$(mktemp)"

editargs() {
	"$EDITOR" "$TMSU_ARGS" < /dev/tty
}

appendargs() {
	while true; do
		RES="$(tmsu tags \
			| fzf -m --print-query --header "Select tag (or write 'tagname+' or any other special character to create a new tag)" \
			|| true)"

		if [ -z "$RES" ]; then
			break
		fi
		SEL="$(printf "%s\n" "$RES" | tail -n+2)"
		QUER="$(printf "%s" "$RES" | head -n 1 | head -c-1)"
		if [ "$SEL" = "" ]; then
			printf "$QUER\n" >> "$TMSU_ARGS"
		else
			printf "$SEL\n" >> "$TMSU_ARGS"
		fi
	done
}

INPUT_FILE="$(mktemp)"
tmsu untagged > "$INPUT_FILE"

# this seems to magically fix some tmsu issue i don't really understand
# tmsu freezes for a second or two
# and then it doesn't apply the tag
cat "$INPUT_FILE" | \
while read -r FILE; do
	if [ -d "$FILE" ] || [ "$(basename "$FILE")" = "db" ]; then
		continue
	fi

	view "$FILE"
	appendargs
	
	while true; do
		printf "%s\n" "$FILE"
		printf "tagging %s with tags:\n" "$FILE"
		cat "$TMSU_ARGS" | sed 's/^/- /'
		printf "\nh view again, j add tmsu args, k edit tmsu args, l confirm, q exit, s skip\n"
		printf "\n> "
		ANS="$(readc </dev/tty)"
		case "$ANS" in
			q ) exit;;
			h ) view "$FILE";;
			j ) appendargs;;
			k ) editargs;;
			l ) printf "\n"
				cat "$TMSU_ARGS" | sed -e '/^$/d' -e "s|^|$FILE |g" | tmsu tag -
				printf "\nPress enter to continue, or enter 'back' to retag\n"
				read ANS </dev/tty
				if [ "$ANS" = "back" ]; then
					tmsu untag -a "$FILE"
				else
					break
				fi;;
			s ) break;;
			* )
				printf "\nInvalid input! Press enter to continue\n";
				read </dev/tty;
				;;
		esac
	done
	printf "" > "$TMSU_ARGS"
done

rm "$TMSU_ARGS"
rm "$INPUT_FILE"
