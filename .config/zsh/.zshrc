autoload -Uz compinit promptinit
compinit

PROMPT='[%F{white}%B%~%b%f] %# '
alias ls='ls --color=auto'

PATH=$PATH:~/.local/bin/

bindkey -v
