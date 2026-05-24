if [ -d "$HOME/bin" ]; then
  export PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ]; then
  export PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "/usr/local/go/bin" ]; then
  export PATH=$PATH:/usr/local/go/bin
fi

if [ -d "$XDG_DATA_HOME/go/bin" ]; then
  export PATH=$PATH:$XDG_DATA_HOME/go/bin
fi

if [ -x "/opt/homebrew/bin/brew" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if [ -f "$CARGO_HOME/env" ]; then
  source "$CARGO_HOME/env"
fi

if [ -f "$HOME/.local/share/npm/bin" ]; then
  export PATH="$PATH:$HOME/.local/share/npm/lib/bin"
fi

if [ -d "$KREW_ROOT" ]; then
  export PATH="${KREW_ROOT}/bin:$PATH"
fi

if [ -s "$BUN_INSTALL" ]; then
  export PATH="$BUN_INSTALL/bin:$PATH"
fi

if [ -d "$HOME/Library/Application Support/JetBrains/Toolbox/scripts" ]; then
  export PATH="$PATH:$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
fi

# macOS: prepend GNU tools so scripts get GNU compat (rust aliases take priority via rust.alias.sh).
# brew install coreutils findutils gnu-sed gawk grep gnu-tar
if [ -x "/opt/homebrew/bin/brew" ]; then
  for _gnu_pkg in coreutils findutils gnu-sed gawk grep gnu-tar; do
    _gnu_bin="$(/opt/homebrew/bin/brew --prefix "$_gnu_pkg" 2>/dev/null)/libexec/gnubin"
    [ -d "$_gnu_bin" ] && export PATH="$_gnu_bin:$PATH"
  done
  unset _gnu_pkg _gnu_bin
fi
