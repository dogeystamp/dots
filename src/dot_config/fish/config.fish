if test -z "$SYSTEM_PROFILE"
	set -gx SYSTEM_PROFILE SLIM
end

# Disable fish greeting
set fish_greeting ""

umask 007

if status --is-interactive
	# prevent mistakes. use -f to override
	alias rm 'rm -i'

	if not test $SYSTEM_PROFILE = "MINIMAL"
		rem.sh show
	end
	source ~/.config/fish/aliases.fish

	# Enable Vi bindings
	fish_hybrid_key_bindings

	source ~/.config/fish/functions/prompts.fish

	set __fish_git_prompt_showdirtystate 1
	set __fish_git_prompt_showupstream auto

	set fish_color_param normal
	set fish_color_cwd grey
	set fish_color_command blue

	if test $SYSTEM_PROFILE = "DEFAULT"
		source ~/.config/fish/functions/extra_prompt.fish
		source ~/.config/fish/functions/fzf_binds.fish
		fzf_key_bindings
	end
	if command -v zoxide > /dev/null
		zoxide init fish | source
	end
end
