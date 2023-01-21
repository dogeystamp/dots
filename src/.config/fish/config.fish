if status is-interactive
    # Commands to run in interactive sessions can go here
end

source ~/.config/fish/aliases.fish

source ~/.config/fish/functions/prompts.fish
source ~/.config/fish/functions/extra_prompt.fish

# Set GPG_TTY
gpgt

# Add .local/bin to path
set -gx PATH "$PATH:$HOME/.local/bin:"
set -gx PATH "$PATH:$HOME/.local/bin/deskutils:"
set -gx PATH "$PATH:$HOME/.local/bin/deskutils/soundboard:"
set -gx PATH "$PATH:$HOME/.local/bin/minrss-scripts:"

set -gx PATH "$PATH:$XDG_DATA_HOME/npm/bin"

# cppman can't set it itself for some reason
set -gx  MANPATH "$MANPATH:/home/dogeystamp/.cache/cppman/"

# Disable fish greeting
set fish_greeting ""

# Enable Vi bindings
fish_vi_key_bindings

bind -M insert \ce accept-autosuggestion -m default
bind -M default \ce execute

set __fish_git_prompt_showdirtystate 1
