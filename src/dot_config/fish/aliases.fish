alias mv='mv -n'
alias cp='cp -n'
alias ls='ls -v --color=auto'

function _git_root --description "Convenience variable for git root." --on-event fish_postexec
    # Git root dir is accessible as $g.
    # Fish completions just work with this.
    set -g g (git rev-parse --show-toplevel 2>/dev/null)
end

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

function darkmode
	niri msg action do-screen-transition
	gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
end
function lightmode
	niri msg action do-screen-transition
	gsettings set org.gnome.desktop.interface color-scheme 'default'
end

function mpv --wraps /usr/bin/mpv; hide mpv mpv $argv; end
function mpvy
    printf "%s\n" (cb -b)
    mpv --profile=network $argv -- (cb -b | sed 's/yewtu\\.be/www.youtube\\.com/g' | sed 's/inv\\.nadeko\\.net/www.youtube\\.com/g')
end

# mpv is better maintained than most other Wayland image viewers
function imvi --description "MPV image viewer" --wraps mpv
    mpv --no-resume-playback --profile=image $argv
end

alias neofetch='fastfetch'
function m --wraps /usr/bin/man; nvim "+hide Man $argv"; end
alias hx='helix'

alias valgrind_='valgrind --error-exitcode=1 --leak-check=full'

alias thur='hide org.pwmt.zathura zathura-sandbox'
function nvimp; nvim -u NONE -c "setlocal history=0 nobackup nomodeline noshelltemp noswapfile noundofile nowritebackup secure viminfo=\"\"" $argv; end
alias nvic 'chezmoi edit -a'
function pdfr; pdftotext $argv - | nvim; end
function arf; mpv --shuffle --no-resume-playback ~/med/memes/arf; end

# notes
function xx; $EDITOR  ~/core/not/xx.tsv; end
function dr; $EDITOR  ~/core/not/dr.txt; end
function bk; $EDITOR  ~/core/not/bk.txt; end
function rem; rem.sh edit; end
function ldg; $EDITOR ~/core/not/journal.ldg; end
function tl; $EDITOR ~/core/not/tasks.txt; end
function ct
    # contains rng seed, changed after every finished session
    set CT_PATH "$XDG_CACHE_HOME"/ct
    touch "$CT_PATH"

    set CT_TASK (shuf --random-source "$CT_PATH" -n 1 ~/core/not/tasks.txt)
    notify-send "$CT_TASK"
    termdown 50m \
        && notify-send "DONE" \
        && head -c 1000 /dev/random > "$CT_PATH"
end

alias ev "khal list"
alias units='units -H ""'
alias xxd='tinyxxd'
alias sched='~/src/kindle-schedule/kindle_schedule.py ~/.local/share/schedule.pdf'
alias sched_upload='scp .local/share/schedule.pdf liber:/mnt/us/documents/'

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

alias c 'chrome_profile.fish'

# git stuff
abbr -a -- gt git switch
abbr -a --position anywhere -- rbsign "--exec 'git commit --amend --no-edit -n -S'"

# datetime
function __date_today; date "+%Y-%m-%d"; end
abbr -a --position anywhere today --function __date_today

# erase sandbox, preserving files given in arguments
function preserve
    mkdir ~/.cache/zoo2 \
    && cp -r $argv ~/.cache/zoo2 \
    && trash ~/zoo \
    && mv ~/.cache/zoo2 ~/zoo
end

function done
    trash ~/ct/now && touch ~/ct/now
end

# directory notes
function dn --description "edit directory notes"
    if ! test -d .dirnotes
        mkdir .dirnotes
        printf "**" > .dirnotes/.gitignore
    end
    $EDITOR ./.dirnotes/notes.txt
end

function dnl --description "list directories with notes"
    # find -type f -name "notes.txt" | xargs dirname | xargs dirname
    fd --type f --hidden --no-ignore --full-path --glob "**/.dirnotes/notes.txt" . \
        | xargs -r dirname | xargs -r dirname
end

function mtx --description "open matrix in single instance"
    pgrep -u $USER iamb; or iamb
end
