function fish_right_prompt
	set -l usercolor (set_color $fish_color_cwd)
	if command -sq cksum
		# randomised color for user/hostname based on disco.fish
		set -l shas (echo $USER@$hostname | cksum | string split -f1 ' ' | math --base=hex | string sub -s 3 | string pad -c 0 -w 6 | string match -ra ..)
		set -l col 0x$shas[1..3]

		# ensure luminance is readable
		while test (math 0.2126 x $col[1] + 0.7152 x $col[2] + 0.0722 x $col[3]) -lt 120
			set col[1] (math --base=hex "min(255, $col[1] + 60)")
			set col[2] (math --base=hex "min(255, $col[2] + 60)")
			set col[3] (math --base=hex "min(255, $col[3] + 60)")
		end
		set -l col (string replace 0x '' $col | string pad -c 0 -w 2 | string join "")

		set usercolor (set_color $col)
	end

    set -l duration "$cmd_duration$CMD_DURATION"
    if test $duration -gt 100
        set duration (math $duration / 1000)s" // "
    else
        set duration
    end

	printf '%s%s%s%s%s' \
		(set_color brgrey) \
		$duration \
		(date +"%H:%M") \
		(set_color normal)
	printf '%s ' \
		(fish_git_prompt)
	printf '%s%s@%s%s'\
		$usercolor \
		(echo $USER | string shorten -m 5 -c '') \
		(echo $hostname | string shorten -m 1 -c '') \
		(set_color normal)
end
function fish_prompt
	printf '%s%s%s> ' (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
end
