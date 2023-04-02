#!/bin/sh
# simple todo utility
# nags me every time i start a shell

set -e

scriptname=$0
subcmd=$1

if [ -z "$REM_FILE" ]; then
	REM_FILE="$HOME/.reminder-file"
	touch "$REM_FILE"
fi

sub_help() {
	echo "usage:"
	echo "  $scriptname <command> [options]"
	echo
	echo "commands:"
	echo "  show               show all entries"
	echo "  add                append new entry"
	echo '  edit               open reminder file in $EDITOR'
	echo
	echo "Set $REM_FILE"
}

sub_show() {
	REMS="$(cat "$REM_FILE" | sed -z 's/^\n$//g')"
	if [ ! -z "$REMS" ]; then
		printf "reminders:\n\n%s\n\n" "$REMS"
	fi
}

sub_add() {
	TMP="$(mktemp)"
	$EDITOR "$TMP"
	cat "$TMP" >> "$REM_FILE"
}

sub_edit() {
	$EDITOR "$REM_FILE"
}

sub_congrats() {
	notify-send -a "🎉" "congrats"
}

case $subcmd in
	"" | "--help" | "-h")
		sub_help
		;;
	*)
		shift
		sub_${subcmd} "$@"
		if [ $? = 127 ]; then
			echo "error: unknown command '$subcmd'"
			exit 1
		fi
		;;
esac
