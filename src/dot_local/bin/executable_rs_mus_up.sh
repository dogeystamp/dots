#!/bin/sh
# Upload music to server.

rsync -rtvP --chown musictx:navidrome ~/med/mus/ navi:/
