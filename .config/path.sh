
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

if [ -f "$CARGO_HOME/env" ] ; then
  source "$CARGO_HOME/env"
fi

if [ -f "$HOME/.local/share/npm/bin" ] ; then
  export PATH="$PATH:$HOME/.local/share/npm/lib/bin"
fi

if [ -d "$KREW_ROOT" ]; then
  export PATH="${KREW_ROOT}/bin:$PATH"
fi

if [ -s "$BUN_INSTALL" ] ; then
  export PATH="$BUN_INSTALL/bin:$PATH"
fi
