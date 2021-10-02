# Color ls 
alias ls='ls --color=auto'

# Limit mpv to 1080p so it doesn't buffer
alias mpv='mpv --ytdl-format="bestvideo[ext=mp4][height<=?1080]+bestaudio[ext=m4a]"'

# Set gpg tty so curses pinentry works
alias gpgt='export GPG_TTY=$(tty)'

# Remove newlines from clipboard (for competitive programming)
alias dnl='xsel -b | tr "\n" " " | xsel -ib'

# Private neovim
alias nvimp='nvim -u NONE -c "setlocal history=0 nobackup nomodeline noshelltemp noswapfile noundofile nowritebackup secure viminfo=\"\""'

# Read pdf file as text
alias pdfr='pdftotext $1 - | nvim'

# Specific to my Gentoo system
alias genlop='doas -u portage /usr/bin/genlop'
alias loginctl='doas /bin/loginctl'

# Delete my gpg key
alias wipekey='gpg --batch --yes --delete-secret-keys 48B4FA19F1BC1603C85762514C53B0126F579F36'
