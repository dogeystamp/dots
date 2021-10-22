if status is-interactive
    # Commands to run in interactive sessions can go here
end

source ~/.config/fish/aliases.fish

set -gx PATH "$PATH:$HOME/.local/bin:"
set fish_greeting ""

fish_vi_key_bindings
