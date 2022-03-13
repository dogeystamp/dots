if status is-interactive
    # Commands to run in interactive sessions can go here
end

source ~/.config/fish/aliases.fish

# Set GPG_TTY
gpgt

# Add .local/bin to path
set -gx PATH "$PATH:$HOME/.local/bin:"

# Disable fish greeting
set fish_greeting ""

# Enable Vi bindings
fish_vi_key_bindings