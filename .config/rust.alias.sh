if [ -x "$(command -v eza)" ]; then
    alias ls="eza"
    alias la="eza -la --git --group-directories-first"
    alias ll="eza -la --git"
    alias tree="eza -la -T -I '.git'"
    alias tree1="eza -la -TL 1 -I '.git'"
    alias tree2="eza -la -TL 2 -I '.git'"
    alias tree3="eza -la -TL 3 -I '.git'"
    alias tree4="eza -la -TL 4 -I '.git'"
else
    alias ll="ls -lAh"
    alias la="ls -lAh"
fi

alias show="cat"
if [ -x "$(command -v bat)" ]; then
    # TODO: case batcat
    alias cat="bat --paging=never"
    alias less="bat --paging=always"
    export GIT_PAGER="bat --plain"
    export PAGER="bat --paging=always"
    alias show="bat --plain"
fi

if [ -x "$(command -v dust)" ]; then
    alias du="dust"
fi

if [ -x "$(command -v ytop)" ]; then
    alias top="ytop"
fi

if [ -x "$(command -v fd)" ]; then
    alias fd="fd -H"
fi

if [ -x "$(command -v eva)" ]; then
    alias calc="eva"
fi
if [ -x "$(command -v bandwhich)" ]; then
    alias bandwidth="sudo ${CARGO_HOME:-$HOME/.cargo}/bin/bandwhich"
fi

if [ -x "$(command -v silicon)" ]; then
    alias silicon="silicon --theme Coldark-Dark -f 'Geist Mono=32'"
fi
