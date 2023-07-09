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

# bootleg meme feed
function arf; cd ~/med/memes/arf; mpv --no-resume-playback (ls | shuf); end

# aliases for logs and notes
function xx; $EDITOR ~/dox/not/xx.tsv; end
function dr; $EDITOR ~/dox/not/dr.txt; end
function bk; $EDITOR ~/dox/not/bk.txt; end
function rem; $EDITOR ~/dox/not/rem; end
function ldg; $EDITOR ~/dox/not/journal.ldg; end

# pocket calculator
function calcpy; python3 ~/.local/bin/calcpy/calcpy_cli.py; end

# disable history on units
alias units='units -H ""'
alias sxiv='nsxiv'

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
function work; qbprof work; end

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
function prob_pdf; echo zathura (basename (xsel -b)).pdf; end
abbr -a pdf --function prob_pdf
