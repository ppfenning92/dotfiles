alias wget=wget --hsts-file="$XDG_DATA_HOME/wget-hsts"

if [ -x "$(command -v nvim)" ]; then 
    alias vim="nvim"
    export GIT_EDITOR="nvim"
fi

alias s="source ~/.config/zsh/.zshrc"

alias json="jq | cat -l json"

alias c="curl -L --silent"
alias t="tmux"

