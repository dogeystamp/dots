# Color ls 
alias ls='ls --color=auto'

# Limit mpv and youtube-dl to 1080p so it doesn't use too much bandwidth
alias mpv='mpv --ytdl-format="bestvideo[ext=mp4][height<=?1080]+bestaudio[ext=m4a]"'

# Run mpv from clipboard, replacing Invidious instances with YouTube's domain
alias mpvy='mpv (xsel -b | sed "s/vid\.mint\.lgbt/youtube\.com/g" | sed "s/yewtu\.be/youtube\.com/g")'

alias youtube-dl='youtube-dl -f "bestvideo[ext=mp4][height<=?1080]+bestaudio[ext=m4a]"'

# Send screenshots to my VM
alias scr='scp ~/med/screen/latest.png boron:~'

# Set gpg tty so curses pinentry works
alias gpgt='export GPG_TTY=(tty)'

# Remove newlines from clipboard (for competitive programming)
alias dnl='xsel -b | tr "\n" " " | xsel -ib'

# Private neovim
alias nvimp='nvim -u NONE -c "setlocal history=0 nobackup nomodeline noshelltemp noswapfile noundofile nowritebackup secure viminfo=\"\""'

# Read pdf file as text
function pdfr
	pdftotext $argv - | nvim
end

# Specific to my Gentoo system
alias genlop='doas -u portage /usr/bin/genlop'
alias loginctl='doas /bin/loginctl'
