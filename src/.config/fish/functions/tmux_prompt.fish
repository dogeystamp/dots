if set -q TMUX

	# python venv style prompt replacement
    functions -c fish_prompt _old_fish_prompt

	function fish_prompt
		printf "%s%s%s" (set_color 809C80) "(tmux) " (set_color normal)
		_old_fish_prompt
	end

	printf "aawagga"
end
