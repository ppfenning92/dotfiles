
if [ -d "$HOME/bin" ] ; then
    export PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ; then
    export PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "/usr/local/go/bin" ] ; then
     export PATH=$PATH:/usr/local/go/bin
fi

if [ -d "$XDG_DATA_HOME/go/bin" ] ; then
     export PATH=$PATH:$XDG_DATA_HOME/go/bin
fi

if [ -f "/opt/homebrew/bin/brew" ] ; then
    eval $(/opt/homebrew/bin/brew shellenv)
fi

if [ -f "/home/p/.local/share/cargo/env" ] ; then
  source "/home/p/.local/share/cargo/env"
fi

if [ -f "/home/p/.local/share/npm/bin" ] ; then
  export PATH=$PATH:/home/p/.local/share/npm/lib/bin
fi

if [ -s "$BUN_INSTALL" ] ; then
  export PATH="$BUN_INSTALL/bin:$PATH"
fi
