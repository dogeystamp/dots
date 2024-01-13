function fish_prompt
	set -l cmd_status $status

	if fish_is_root_user
		set letter '#'
	else
		set letter '>'
	end

	set -l usercolor (set_color brgrey)

	set -l stat_code ""
	if test $cmd_status -ne 0
		set stat_code " "(set_color red)(fish_status_to_signal $cmd_status)
	end

	printf '%s%s@%s%s%s%s '\
		$usercolor \
		(echo $USER | string shorten -m 5 -c '') \
		(echo $hostname | string shorten -m 3 -c '') \
		$stat_code \
		(set_color normal) \
		(fish_git_prompt)
		
	printf '%s%s%s%s ' (set_color $fish_color_cwd) (prompt_pwd) (set_color normal) $letter
end

# https://fishshell.com/docs/3.2/cmds/fish_mode_prompt.html
function fish_mode_prompt
	if command -sq cksum
		# randomised color for user/hostname based on disco.fish
		set -l shas (echo $USER$hostname | cksum | string split -f1 ' ' | math --base=hex | string sub -s 3 | string pad -c 0 -w 6 | string match -ra ..)
		set -l col 0x$shas[1..3]

		# ensure luminance is readable
		while test (math 0.2126 x $col[1] + 0.7152 x $col[2] + 0.0722 x $col[3]) -lt 120
			set col[1] (math --base=hex "min(255, $col[1] + 60)")
			set col[2] (math --base=hex "min(255, $col[2] + 60)")
			set col[3] (math --base=hex "min(255, $col[3] + 60)")
		end
		set -l col (string replace 0x '' $col | string pad -c 0 -w 2 | string join "")

		set uniquecol (set_color --bold $col)
	end

	set_color --bold brgrey
	echo '['
	echo $uniquecol

	switch $fish_bind_mode
	case default
		echo 'N'
	case insert
		echo 'I'
	case replace_one
		echo 'R'
	case visual
		echo 'V'
	case '*'
		echo '?'
	end

	set_color --bold brgrey
	echo '] '
	set_color normal
end
