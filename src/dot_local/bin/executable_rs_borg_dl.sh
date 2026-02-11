#!/bin/sh
# Pull server backups
rsync --stats -av --delete --exclude '.ssh' --exclude '.cache' borg:oriens borg:meridies sv/
