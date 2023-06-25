if [ -x "$(command -v exa)" ]; then
  alias ls="exa"
  alias la="ls -laFhHumG"
  alias ll="ls -laF"
  alias tree="ls -laHT "
  alias tree1="ls -laHTL 1"
  alias tree2="ls -laHTL 2"
  alias tree3="ls -laHTL 3"
  alias tree4="ls -laHTL 4"
else
  echo "exa is not installed"
  alias ll="ls -lAF"
fi

if [ -x "$(command -v bat)" ]; then
    alias cat="bat --paging=never"
    alias less="bat --paging=always"
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
    alias bandwidth="sudo ~/.cargo/bin/bandwhich"
fi