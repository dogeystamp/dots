# dynamic swallow
function hide
	if test -n "$NIRI_SOCKET"
		niri-swal.sh $argv
	else if command -v dwmswallow > /dev/null; then
		dwmswallow "$WINDOWID" $argv[2..-1]
	else
		eval $argv[2..-1]
	end
end

function darkmode
	niri msg action do-screen-transition
	gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
end
function lightmode
	niri msg action do-screen-transition
	gsettings set org.gnome.desktop.interface color-scheme 'default'
end

alias mpv='hide mpv mpv'
alias imvi='hide swayimg imgv.sh'

alias neofetch='fastfetch'

# prevent clobbering files
alias mv='mv -n'
alias cp='cp -n'

# zathura
alias thur='hide org.pwmt.zathura zathura'
# stricter sandbox zathura
alias zathsec='/usr/bin/zathura-sandbox -c ~/.config/zathura-sec'

# tmux with 256-color and UTF-8
function tmx; tmux -u -2 $argv; end

# Run mpv from clipboard
function mpvy; mpv $argv (cb -b); end

# Set gpg tty so curses pinentry works
function gpgt; export GPG_TTY=(tty); end

# Private neovim
function nvimp; nvim -u NONE -c "setlocal history=0 nobackup nomodeline noshelltemp noswapfile noundofile nowritebackup secure viminfo=\"\"" $argv; end

# Edit configuration file
alias nvic 'chezmoi edit -a'

# Read pdf file as text
function pdfr
	pdftotext $argv - | nvim
end

# Neomutt configs
function neomutt.local; neomutt -F .config/neomutt/neomuttrc.local; end

# bootleg meme feed
function arf; mpv --shuffle --no-resume-playback ~/med/memes/arf; end

# aliases for logs and notes
function xx; $EDITOR ~/dox/not/xx.tsv; end
function dr; $EDITOR ~/dox/not/dr.txt; end
function bk; $EDITOR ~/dox/not/bk.txt; end
function rem; $EDITOR ~/dox/not/rem; end
function ldg; $EDITOR ~/dox/not/journal.ldg; end

# disable history on units
alias units='units -H ""'

alias sxiv='nsxiv'
alias xxd='tinyxxd'

# music recognition
# an alternative is available at ~/.local/bin/msrec
# which uses a different service
function musrec
	# if file exists
	if test -e $argv
		# recognize it
		http --form POST "https://api.audd.io?api_token=$(cat ~/.config/audd_token)" file@$argv
	end
end

#
# qutebrowser profiles
#
# listenbrainz
function lstb; qbprof lstb; end
# paperless
function papr; qbprof papr; end
function work; qbprof work; end
function chat; qbprof chat; end
function zoom; qbprof zoom; end

# git stuff
abbr -a -- gs git status
abbr -a -- gt git switch
abbr -a -- gl git log
abbr -a -- ga git add
abbr -a -- gcs git commit -S
abbr -a -- gc git commit
abbr -a -- gca git commit -a
abbr -a -- gas git commit -aS
abbr -a -- gp git push
abbr -a --position anywhere -- pgh "&& git push gh"
abbr -a --position anywhere -- rbsign "--exec 'git commit --amend --no-edit -n -S'"

# problem solving
# ---------------
# use abbreviations instead of aliases/functions because
# this allows retrieving the files accessed from history
# instead of (basename (xsel -b))

function prob_typ; echo $EDITOR (basename (xsel -b)).typ; end
abbr -a typ --function prob_typ
function prob_cpp; echo $EDITOR src/(basename (xsel -b)).cpp; end
abbr -a cpp --function prob_cpp
function prob_py; echo $EDITOR src/(basename (xsel -b)).py; end
abbr -a py --function prob_py

# creates a debug directory for a file
# see src/.config/nvim/lua/debugging.lua
function dbgd
	set -l dir $XDG_CACHE_HOME/nvimdbg(realpath $argv)
	mkdir -p $dir
	cd $dir
end
