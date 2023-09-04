#!/bin/sh

# Installs dotfiles and Python packages

set -e

SCRIPT_NAME="$(basename $0)"

# Default source for dotfiles
SRCFOLDER="$(dirname "$0")/src/"
PYREQS="$(realpath "$(dirname "$0")/programs-python")"
DESTFOLDER="$HOME"

# Allow overwriting of outdated files
FORCE="N"
VERBOSE="N"
INSTALL_PYTHON="N"

display_help () {
cat >&2 <<EOF 
usage: $SCRIPT_NAME [-h] [-v] [-f] [-s PATH] [-d PATH]
	-h: display help
	-f: allow overwriting existing dotfiles
	-p: installs python packages via pipx
	-v: print modified files
	-s: path to source of dotfiles
	-d: path to destination where dotfiles are linked from
EOF
}

while getopts "fvphs:d:" o; do
	case "$o" in
		h) 
			display_help
			exit 0
			;;
		f) FORCE="Y" ;;
		v) VERBOSE="Y" ;;
		p) INSTALL_PYTHON="Y" ;;
		s)
			DESTFOLDER="$OPTARG"
			;;
		d)
			DESTFOLDER="$OPTARG"
			;;
	esac
done

if ! [ -d "$SRCFOLDER" ]; then
	printf "$SCRIPT_NAME: source folder $SRCFOLDER is invalid.\n"
	exit 1
fi

if ! [ -d "$DESTFOLDER" ]; then
	printf "$SCRIPT_NAME: destination $DESTFOLDER is invalid.\n"
	exit 1
fi

cd $SRCFOLDER

for f in $(find -type d); do
	DIR=$DESTFOLDER$(echo $f | cut -c 2-)
	
	if ! [ -d "$DIR" ]; then
		if [ "$VERBOSE" = "Y" ]; then
			printf "$DIR\n"
		fi
		mkdir $DIR
	fi
done

link () {
	SRC="$1"
	DEST="$2"
	OPTS="$3"

	ln -s $OPTS "$SRC" "$DEST"

	if [ "$VERBOSE" = "Y" ]; then
		printf "$2\n"
	fi
}

for f in $(find -type f); do
	DEST="$DESTFOLDER$(echo $f | cut -c 2-)"
	SRC="$PWD$(echo $f | cut -c 2-)"
	if [ -e "$DEST" ]; then
		if ! [ "$SRC" -ef "$DEST" ]; then
			if [ "$FORCE" = "Y" ]; then
				link "$SRC" "$DEST" -f
			else
				printf "$SCRIPT_NAME: $DEST already exists\n" >&2
			fi
		fi
	else
		link "$SRC" "$DEST"
	fi
done

printf "Symlinked dotfiles.\n" >&2

if [ "$INSTALL_PYTHON" = "Y" ]; then
	if command -v pipx > /dev/null; then
		printf "Installing Python packages via pipx...\n" >&2
		cat "$PYREQS" | sed "/#.*/d" | xargs -I{} pipx install {}
	else
		printf "'pipx' is missing. Not installing Python packages...\n" >&2
	fi
fi
