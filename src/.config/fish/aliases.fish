# Run mpv from clipboard
function mpvy; mpv (xsel -b); end

# Set gpg tty so curses pinentry works
function gpgt; export GPG_TTY=(tty); end

# Private neovim
function nvimp; nvim -u NONE -c "setlocal history=0 nobackup nomodeline noshelltemp noswapfile noundofile nowritebackup secure viminfo=\"\""; end

# Read pdf file as text
function pdfr
	pdftotext $argv - | nvim
end

# Neomutt configs
function neomutt.local; neomutt -F .config/neomutt/neomuttrc.local; end
function neomutt.disroot; neomutt -F .config/neomutt/neomuttrc.disroot; end
function neomutt.work; neomutt -F .config/neomutt/neomuttrc.work; end

# Specific to my Gentoo system
function genlop; doas -u portage /usr/bin/genlop; end
function loginctl; doas /bin/loginctl; end

function pyenv; source ~/dox/proj/ref/venv/bin/activate.fish; end

# bootleg meme feed
function arf; cd ~/med/memes/arf; mpv --no-resume-playback (ls | shuf); end

# aliases for logs and notes
function xx; $EDITOR ~/dox/not/xx.tsv; end
function dr; $EDITOR ~/dox/not/dr.txt; end
function bk; $EDITOR ~/dox/not/bk.txt; end
function rem; $EDITOR ~/dox/not/rem; end

# music recognition
function musrec
	# if file exists
	if test -e $argv
		# recognize it
		http --form POST "https://api.audd.io?api_token=$(cat ~/.config/audd_token)" file@$argv
	end
end
