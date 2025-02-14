XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
DIRSH_CONFIG_FORMAT="${DIRSH_CONFIG_FORMAT:-yaml}" # Default: JSON
DIRSH_APPROVAL_FILE="$XDG_STATE_HOME/dirsh/approved.${DIRSH_CONFIG_FORMAT}"
DIRSH_ENV_FILE=".envrc"
DIRSH_DEBUG="1"
DIRSH_QUIET=""
DIRSH_ASSUME_YES="" # if you also `curl --silent | bash -c`

_debug() {
  if [[ -n "$DIRSH_DEBUG" ]]; then
    echo "\033[3;36mdirsh:\033[0m \033[1;36m[DBG]\033[0m\033[10;36m $1\033[0m"
  fi
}

_print() {
  if [[ -z "$DIRSH_QUIET" ]]; then
    echo "\033[3;37mdirsh:\033[0m \033[1;37m[LOG]\033[0m\033[10;37m $1\033[0m"
  fi
}

_error() {
  echo "\033[3;91mdirsh:\033[0m \033[1;91m[ERR]\033[0m\033[10;91m $1\033[0m"
}

_call_func() {
  declare -f -F "$1" &>/dev/null && "$1"
}

ensure_approval_file() {
  mkdir -p "$(dirname "$DIRSH_APPROVAL_FILE")"
  if [ ! -f "$DIRSH_APPROVAL_FILE" ]; then
    case "$DIRSH_CONFIG_FORMAT" in
    json) echo '{}' >"$DIRSH_APPROVAL_FILE" ;;
    yaml) echo "approved_dirs: {}" >"$DIRSH_APPROVAL_FILE" ;;
    toml)
      echo "toml not supported at this moment"
      exit 1
      ;;
    esac
  fi
}

# Select appropriate parsing commands
case "$DIRSH_CONFIG_FORMAT" in
json)
  CONFIG_TOOL="jq"
  ;;
yaml | toml)
  CONFIG_TOOL="yq"
  ;;
*)
  _error "Unsupported config format: $DIRSH_CONFIG_FORMAT"
  return 1
  ;;
esac

is_dir_approved() {
  _debug "Checking approval for directory: $PWD"

  # Ensure the approval file exists
  [ ! -f "$DIRSH_APPROVAL_FILE" ] && _error "Approval file not found." && return 1

  case "$DIRSH_CONFIG_FORMAT" in
  json)
    is_approved=$(jq -e --arg dir "$PWD" '.approved_dirs[$dir].approved // false' "$DIRSH_APPROVAL_FILE" 2>/dev/null) || {
      _error "Error checking approval in JSON config."
      return 1
    }
    last_hash=$(jq -e --arg dir "$PWD" '.approved_dirs[$dir].hash // false' "$DIRSH_APPROVAL_FILE" 2>/dev/null) || {
      _error "Error checking approval in JSON config."
      return 1
    }
    ;;
  yaml | toml)
    is_approved=$(yq eval '.approved_dirs["'"$PWD"'"].approved // false' "$DIRSH_APPROVAL_FILE" 2>/dev/null) || {
      _error "Error checking approval in $DIRSH_CONFIG_FORMAT config."
      return 1
    }
    last_hash=$(yq eval '.approved_dirs["'"$PWD"'"].hash // false' "$DIRSH_APPROVAL_FILE" 2>/dev/null) || {
      _error "Error checking approval in $DIRSH_CONFIG_FORMAT config."
      return 1
    }
    ;;
  *)
    _error "Unsupported config format: $DIRSH_CONFIG_FORMAT"
    return 1
    ;;
  esac

  # Check if directory is approved
  if [[ "$is_approved" == "false" || -z "$is_approved" ]]; then
    _print "Directory '$PWD' is not approved."
    return 1
  fi

  file_hash=$(sha256sum "$DIRSH_ENV_FILE" | awk '{print $1}')
  _debug "$DIRSH_ENV_FILE -> $file_hash"
  if [[ -z "$last_hash" || "$last_hash" != "$file_hash" ]]; then
    _print "File has changed."
    return 1
  fi

  _debug "Directory '$PWD' is approved."
  return 0
}

set_dir_approval() {
  local dir="$PWD"
  local approval="$1"
  local hash
  hash=$(sha256sum "$DIRSH_ENV_FILE" | awk '{print $1}')
  local tmp_file="${DIRSH_APPROVAL_FILE}.tmp"

  case "$DIRSH_CONFIG_FORMAT" in
  json)
    jq --arg dir "$dir" --argjson approval "$approval" --arg hash "$hash" \
      '.approved_dirs[$dir] = { "approved": $approval, "hash": $hash }' \
      "$DIRSH_APPROVAL_FILE" >"$tmp_file" && mv "$tmp_file" "$DIRSH_APPROVAL_FILE"
    ;;
  yaml)
    yq eval '.approved_dirs["'"$dir"'"] = {"approved": "'"$approval"'", "hash": "'"$hash"'"}' \
      "$DIRSH_APPROVAL_FILE" >"$tmp_file" && mv "$tmp_file" "$DIRSH_APPROVAL_FILE"
    ;;
  esac
}

prompt_for_approval() {
  bat "$PWD/$DIRSH_ENV_FILE" -lbash --style=snip,numbers,header
  echo -n "dirsh: Source environment for '$PWD'? [y/N] "
  read -r response
  case "$response" in
  [Yy]*)
    set_dir_approval true
    return 0
    ;;
  *)
    set_dir_approval false
    return 1
    ;;
  esac
}
echo "test"
typeset -A _dirsh_cache

_dirsh_hook() {

  if [ ${_dirsh_cache["$PWD"]} ] && [ ${_dirsh_cache["$PWD"]} = 1 ]; then
    _debug "Already ran, skipping"
    return
  fi

  ensure_approval_file

  for cmd in "$CONFIG_TOOL" rg bat glow; do
    command -v "$cmd" &>/dev/null || {
      _error "Missing required command: $cmd"
      return 1
    }
  done

  _debug "$OLDPWD -> $PWD"
  # if [[ -n "$DIRSH_DEBUG" ]]; then
  #   for key value in ${(kv)_dirsh_cache}; do
  #     _debug "_dirsh_cache[$key]=$value"
  #   done
  # fi

  # Check if moving up (not into a subdirectory)
  if [[ "$OLDPWD" != "$PWD" && -f "$OLDPWD/$DIRSH_ENV_FILE" && ! "$PWD" =~ ^"$OLDPWD"/.* && ${_dirsh_cache["$OLDPWD"]} != 0 ]]; then
    _print "Unloading..."

    _call_func _unload

    unset -f _load &>/dev/null
    unset -f _unload &>/dev/null

    _dirsh_cache["$OLDPWD"]=0
  fi

  if [[ -f "$PWD/$DIRSH_ENV_FILE" ]]; then
    if ! is_dir_approved && [ -z "$DIRSH_ASSUME_YES" ]; then
      prompt_for_approval || return
    fi

    _print "Loading $DIRSH_ENV_FILE"

    source "$PWD/$DIRSH_ENV_FILE" &>/dev/null

    _call_func _load

    _dirsh_cache["$PWD"]=1
  fi
}

typeset -ag precmd_functions

if [[ -z ${precmd_functions[_dirsh_hook]} ]]; then
  precmd_functions+=_dirsh_hook
fi

# GistID: 87c59acf3b53cf1911bc6e3a8055afbf
# vim: ft=bash ts=2 sts=2 sw=2 et
