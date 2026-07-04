function fish_prompt
    # preserve prior command status
	set -l cmd_status $status

	set -l fish_color_cwd (set_color white)
    set -l fish_color_vcs (set_color white)
    set -l fish_color_letter (set_color white)
    set -l fish_color_status (set_color --reverse red)
    set -l fish_color_login (set_color white)

    set -l components

    # VCS
    set -l vcs (vcs_prompt)
    if test -n "$vcs"
        set -a components $fish_color_vcs$vcs
    end

    # Command status
    if test $cmd_status -ne 0
        set -a components $fish_color_status(fish_status_to_signal $cmd_status)
    end

    # User/host
    if status is-login
        set -a components $fish_color_login(prompt_login)
    end

    # PWD + final letter
    if fish_is_root_user
        set letter '#'
    else
        set letter '>'
    end
    set -a components $fish_color_cwd(prompt_pwd)$fish_color_letter$letter

    printf "%s " (string join (set_color normal)" " $components)
end

# https://fishshell.com/docs/3.2/cmds/fish_mode_prompt.html
function fish_mode_prompt
	# i usually consider the cursor to be good enough for distinguishing visual/insert.
	# no-op.
end
