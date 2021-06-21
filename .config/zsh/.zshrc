autoload -Uz compinit promptinit
compinit
promptinit

prompt redhat
alias ls='ls --color=auto'
alias nvid='neovide --multiGrid'

PATH=$PATH:~/.local/bin/

bindkey -v

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
