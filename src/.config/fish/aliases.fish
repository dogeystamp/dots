# Color ls 
alias ls='ls --color=auto'

# Run mpv from clipboard
alias mpvy='mpv (xsel -b)'

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

# Neomutt configs
alias neomutt.local='neomutt -F .config/neomutt/neomuttrc.local'
alias neomutt.disroot='neomutt -F .config/neomutt/neomuttrc.disroot'

# Specific to my Gentoo system
alias genlop='doas -u portage /usr/bin/genlop'
alias loginctl='doas /bin/loginctl'

alias pyenv='source ~/dox/proj/ref/venv/bin/activate.fish'
