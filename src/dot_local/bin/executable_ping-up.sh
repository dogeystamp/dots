#!/bin/sh
# ping until successful, then alert

while true; do
	if ping -c 1 $1; then
		echo Ping successful
		notify-send -a "ping-up" "Ping is successful"
		cat << 'EOF'
   ___ _               _ 
  / _ (_)_ __   __ _  / \
 / /_)/ | '_ \ / _` |/  /
/ ___/| | | | | (_| /\_/ 
\/    |_|_| |_|\__, \/   
               |___/     
EOF
		tput bel
		break
	else
		sleep 1
	fi
done
