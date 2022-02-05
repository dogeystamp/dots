#!/bin/sh

cd $(dirname $(echo $0))/src/

echo Making directories
for f in $(find -type d); do
	DIR=$HOME$(echo $f | cut -c 2-)
	echo $DIR
	mkdir $DIR
done

echo Symlinking dotfiles
for f in $(find -type f); do
	DEST=$HOME$(echo $f | cut -c 2-)
	SRC=$PWD$(echo $f | cut -c 2-)
	echo $SRC $DEST
	ln -s $SRC $DEST
done
