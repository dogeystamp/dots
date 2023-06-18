#!/bin/sh
# Sets up env vars and configs for things I don't want to expose in my dotfiles

# - install libsecret
# - set up keepassxc
# 	- tools -> settings -> secret service integration -> enable integration
# 	- expose database:
# 		- click on the edit icon in exposed database groups
# 		- secret service integration
# 		- "expose entries under this group"
# 		- select a group to expose
# - use secret-tool to import configs into keepassxc
# 	for example:
# 		
# 		cat .config/aerc/accounts.conf | secret-tool store --label="aerc-conf" Title aerc-conf
#
# 	you can use the same command to update the entry
#
# this script takes these secret files and deploys them to the system
# you need to have keepassxc running to use it

secret-tool lookup Title "conf-aerc-accounts" > .config/aerc/accounts.conf
secret-tool lookup Title "conf-identity" > .config/identity
