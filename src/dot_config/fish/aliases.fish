function hide --description "swallow window"
    if test $argv[-1] = "--list-options"
        return
    end

	if test -n "$NIRI_SOCKET"
		niri-swal.sh $argv
	else
		eval $argv[2..-1]
	end
end

function mpv; hide mpv mpv $argv; end
function darkmode;
	niri msg action do-screen-transition
	gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
end
function lightmode
	niri msg action do-screen-transition
	gsettings set org.gnome.desktop.interface color-scheme 'default'
end
function imvi --wraps swayimg; hide swayimg swayimg $argv; end
alias neofetch='fastfetch'
function mann --wraps man; nvim "+hide Man $argv"; end
alias hx='helix'
alias mv='mv -n'
alias cp='cp -n'
alias thur='hide org.pwmt.zathura zathura'
alias zathsec='/usr/bin/zathura-sandbox -c ~/.config/zathura-sec'
function tmx; tmux -u -2 $argv; end
function mpvy; mpv --profile=network $argv -- (cb -b | sed 's/yewtu\\.be/www.youtube\\.com/g'); end
function nvimp; nvim -u NONE -c "setlocal history=0 nobackup nomodeline noshelltemp noswapfile noundofile nowritebackup secure viminfo=\"\"" $argv; end
alias nvic 'chezmoi edit -a'
function pdfr; pdftotext $argv - | nvim; end
function arf; mpv --shuffle --no-resume-playback ~/med/memes/arf; end
function xx; $EDITOR  ~/core/not/xx.tsv; end
function dr; $EDITOR  ~/core/not/dr.txt; end
function bk; $EDITOR  ~/core/not/bk.txt; end
function rem; $EDITOR ~/core/not/rem; end
function ldg; $EDITOR ~/core/not/journal.ldg; end
alias ev "khal list"
alias units='units -H ""'
alias xxd='tinyxxd'
alias sched='~/src/kindle-schedule/kindle_schedule.py ~/.local/share/schedule.pdf'

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

# datetime
function __date_today; date "+%Y-%m-%d"; end
abbr -a --position anywhere today --function __date_today
