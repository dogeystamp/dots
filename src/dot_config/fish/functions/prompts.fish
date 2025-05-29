function fish_prompt
	set -l cmd_status $status

	if fish_is_root_user
		set letter '#'
	else
		set letter '>'
	end

	set -l fish_color_cwd white

	set -l stat_code ""
	if test $cmd_status -ne 0
		set stat_code (set_color --reverse red)(fish_status_to_signal $cmd_status)(set_color normal)" "
	end

	set -l git_prompt (string trim (fish_git_prompt))
	if test -n $fish_git_prompt
		set git_prompt $git_prompt" "
	end

	printf '%s%s%s%s'\
		(set_color --italic red) \
		$git_prompt \
		$stat_code \
		(set_color normal)
		
	printf '%s%s%s%s%s ' (set_color $fish_color_cwd) (prompt_pwd) (set_color cyan) $letter (set_color normal)
end

# https://fishshell.com/docs/3.2/cmds/fish_mode_prompt.html
function fish_mode_prompt
	# i usually consider the cursor to be good enough for distinguishing visual/insert.
	# no-op.
end
