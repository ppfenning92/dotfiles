alias wget=wget --hsts-file="$XDG_DATA_HOME/wget-hsts"

if [ -x "$(command -v nvim)" ]; then 
    alias vim="nvim"
    export GIT_EDITOR="nvim"
fi

alias s="source ~/.config/zsh/.zshrc"

alias json="jq | cat -l json"

alias c="curl -L --silent"
alias t="tmux"


alias shell-keys="curl -s 'https://gist.githubusercontent.com/2KAbhishek/9c6d607e160b0439a186d4fbd1bd81df/raw/244284c0b3e40b2b67697665d2d61e537e0890fc/Shell_Keybindings.md'  | PAGER='bat --plain'; glow"
