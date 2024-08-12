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

	function fish_prompt
		printf "%s%s%s" (set_color 8080FF) "(ssh) " (set_color normal)
		ssh_old_fish_prompt
	end
end
