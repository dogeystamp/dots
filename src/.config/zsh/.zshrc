autoload -Uz compinit promptinit

bindkey -v

compinit

promptinit
prompt redhat

SAVEHIST=500

PATH=$PATH:~/.local/bin/


# This is where these files are on my Gentoo system
source /usr/share/zsh/site-functions/zsh-syntax-highlighting.zsh
source ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# On my Arch systems
# source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Load aliases
source ~/.config/zsh/aliases.zsh

# Fix bug with curses pinentry
gpgt
