# GistID: 87c59acf3b53cf1911bc6e3a8055afbf

_call_func () {
  declare -f -F "$1" && $1
}

DIRSH_ENTER_FILE=".envrc"
DIRSH_EXIT_FILE=".envrc"

typeset -A _dirsh_cache
# TODO: allow/deny list
# hash env file
# use XDG_STATE_HOME as configstrore

# TODO: unload only when leaving dir tree above
# going further down, should not trigger unload


_dirsh_hook () {
  
  [ ${_dirsh_cache["$PWD"]} ] && [ ${_dirsh_cache["$PWD"]} = 1 ] && return

  if [ "$OLDPWD" != "$HOME" ] && [ -f "$OLDPWD/$DIRSH_EXIT_FILE" ]; then
    echo "dirsh: unloading"
    source "$OLDPWD/$DIRSH_EXIT_FILE" &>/dev/null
    _call_func "_unload" &>/dev/null
    unset -f _load 
    unset -f _unload
    _dirsh_cache["$OLDPWD"]=0
  fi
  
  if [ "$PWD" != "$HOME" ] && [ -f "$PWD/$DIRSH_ENTER_FILE" ]; then
    echo "dirsh: loading .zshrc"
    source "$PWD/$DIRSH_ENTER_FILE" &>/dev/null
    _call_func "_load" &>/dev/null
    _dirsh_cache["$PWD"]=1
  fi

}

typeset -ag precmd_functions;

if [[ -z ${precmd_functions[_dirsh_hook]} ]]; then
  precmd_functions+=_dirsh_hook
fi
