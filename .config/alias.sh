alias wget=wget --hsts-file="$XDG_DATA_HOME/wget-hsts"

export GIT_PAGER="vim"
if [ -x "$(command -v nvim)" ]; then 
    alias vim="nvim"
    export GIT_PAGER="nvim"
fi
