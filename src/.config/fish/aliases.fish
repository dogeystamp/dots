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

# Specific to my Gentoo system
function genlop; doas -u portage /usr/bin/genlop; end
function loginctl; doas /bin/loginctl; end

function pyenv; source ~/dox/proj/ref/venv/bin/activate.fish; end
