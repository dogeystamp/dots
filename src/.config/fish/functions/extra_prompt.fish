# python venv style prompt replacement

if set -q TMUX
    functions -c fish_prompt tmux_old_fish_prompt

	function fish_prompt
		printf "%s%s%s" (set_color 809C80) "(tmux) " (set_color normal)
		tmux_old_fish_prompt
	end
end

if set -q SSH_AGENT_PID
    functions -c fish_prompt ssha_old_fish_prompt

	function fish_prompt
		printf "%s%s%s" (set_color 9C8080) "(ssha) " (set_color normal)
		ssha_old_fish_prompt
	end
end

if set -q SSH_TTY
    functions -c fish_prompt ssh_old_fish_prompt

	function fish_prompt
		printf "%s%s%s" (set_color 80809C) "(ssh) " (set_color normal)
		ssh_old_fish_prompt
	end
end
