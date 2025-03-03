# python venv style prompt replacement

if set -q TMUX
    functions -c fish_prompt tmux_old_fish_prompt

	function fish_prompt
		printf "%s%s%s" (set_color 809C80) "(tmux) " (set_color normal)
		tmux_old_fish_prompt
	end
end

if set -q SSH_TTY
    functions -c fish_prompt ssh_old_fish_prompt

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

	function fish_prompt
		set -l usercolor (set_color brblack)

		printf "%s(ssh) %s%s@%s " \
			$uniquecol \
			$usercolor \
			(echo $USER | string shorten -m 5 -c '') \
			(echo $hostname | string shorten -m 3 -c '')
		ssh_old_fish_prompt
	end
end
