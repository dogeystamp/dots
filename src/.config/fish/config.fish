if test -z "$SYSTEM_PROFILE"
	set -gx SYSTEM_PROFILE SLIM
end

source ~/.config/fish/aliases.fish

# Set GPG_TTY
gpgt

# Add .local/bin to path
set -gx PATH "$PATH:$HOME/.local/bin:"
set -gx PATH "$PATH:$HOME/.local/bin/deskutils:"
set -gx PATH "$PATH:$HOME/.local/bin/deskutils/soundboard:"

set -gx PATH "$PATH:$XDG_DATA_HOME/npm/bin"

# cppman can't set it itself for some reason
set -gx  MANPATH "$MANPATH:/home/dogeystamp/.cache/cppman/"

# Disable fish greeting
set fish_greeting ""

if status --is-interactive
	# Enable Vi bindings
	fish_hybrid_key_bindings

	source ~/.config/fish/functions/prompts.fish

	set __fish_git_prompt_showdirtystate 1
	set __fish_git_prompt_showupstream auto

	set fish_color_param normal
	set fish_color_cwd grey

	if test $SYSTEM_PROFILE = "DEFAULT"
		source ~/.config/fish/functions/extra_prompt.fish
		source ~/.config/fish/functions/fzf_binds.fish
		fzf_key_bindings
		rem.sh show
	end
end
