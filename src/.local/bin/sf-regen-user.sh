#!/bin/sh
# regen /home/user on segfault.net free servers
 
rm -rf /sec/home/user
mkdir /home/user
chown user:user /home/user
chmod 700 /home/user
runuser user -s /bin/sh -c "git clone https://github.com/dogeystamp/dots.git ~/dots"
runuser user -s /bin/sh -c "~/dots/dotinstall.sh"
