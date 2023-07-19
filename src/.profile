#!/bin/sh

. ~/.config/vars

if [ "$SYSTEM_PROFILE" = "DEFAULT" ]; then
	eval $(ssh-agent)
fi

. ~/.config/bashrc
