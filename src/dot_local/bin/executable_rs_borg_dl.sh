#!/bin/sh
# Pull server backups
rsync -av --exclude '.ssh' --exclude '.cache' borg:oriens sv/
