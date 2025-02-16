XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
DIRSH_CONFIG_FORMAT="${DIRSH_CONFIG_FORMAT:-yaml}" # Default: YAML
DIRSH_APPROVAL_FILE="$XDG_STATE_HOME/dirsh/approved.${DIRSH_CONFIG_FORMAT}"
DIRSH_ENV_FILE=".envrc"
DIRSH_DEBUG="1"
DIRSH_QUIET=""
DIRSH_ASSUME_YES="" # if you also pipe curl to sudo shells
DIRSH_ACTIVE_ENV=""

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
  >&2 echo "\033[3;91mdirsh:\033[0m \033[1;91m[ERR]\033[0m\033[10;91m $1\033[0m"
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

for cmd in "$CONFIG_TOOL" rg bat glow; do
  command -v "$cmd" &>/dev/null || {
    _error "Missing required command: $cmd"
    return 1
  }
done

mkdir -p "$(dirname "$DIRSH_APPROVAL_FILE")"
if [ ! -f "$DIRSH_APPROVAL_FILE" ]; then
  case "$DIRSH_CONFIG_FORMAT" in
  json) echo '{}' >"$DIRSH_APPROVAL_FILE" ;;
  yaml) echo "approved_dirs: {}" >"$DIRSH_APPROVAL_FILE" ;;
  toml)
    _error "toml not supported at this moment"
    return 1
    ;;
  esac
fi

_call_func() {
  declare -f -F "$1" &>/dev/null && "$1"
}

_should_ask_to_load() {
  _debug "Checking approval for directory: $PWD"

  # Ensure the approval file exists
  [ ! -f "$DIRSH_APPROVAL_FILE" ] && _error "Approval file not found." && 106

  case "$DIRSH_CONFIG_FORMAT" in
  json)
    is_approved=$(jq -e --arg dir "$PWD" '.approved_dirs[$dir].approved // "na"' "$DIRSH_APPROVAL_FILE" 2>/dev/null)
    last_hash=$(jq -e --arg dir "$PWD" '.approved_dirs[$dir].hash // 0' "$DIRSH_APPROVAL_FILE" 2>/dev/null)
    ;;
  yaml | toml)
    is_approved=$(yq eval '.approved_dirs["'"$PWD"'"].approved // "na"' "$DIRSH_APPROVAL_FILE" 2>/dev/null)
    last_hash=$(yq eval '.approved_dirs["'"$PWD"'"].hash // 0' "$DIRSH_APPROVAL_FILE" 2>/dev/null)
    ;;
  *)
    _error "Unsupported config format: $DIRSH_CONFIG_FORMAT"
    return 105
    ;;
  esac

  _debug "is_approved: $is_approved, last_hash: $last_hash"

  if [[ "$is_approved" == "na" ]]; then
    _debug "Directory not found in '$DIRSH_APPROVAL_FILE'"
    return 10
  fi

  # Check if directory is approved
  if [[ "$is_approved" == "false" || -z "$is_approved" ]]; then
    _print "Directory '$PWD' is not approved."
    return 20
  fi

  file_hash=$(sha256sum "$DIRSH_ENV_FILE" | awk '{print $1}')
  _debug "$DIRSH_ENV_FILE -> $file_hash"
  if [[ -z "$last_hash" || "$last_hash" != "$file_hash" ]]; then
    _print "File has changed."
    return 30
  fi

  _debug "Directory '$PWD' is approved."
  return 40
}

_set_dir_approval() {
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

_prompt_for_approval() {
  if [[ -n "$DIRSH_ASSUME_YES" ]]; then
    _debug "Assume yes"
    _set_dir_approval true
    return 0
  fi

  bat "$PWD/$DIRSH_ENV_FILE" -lbash --style=snip,numbers,header
  echo -n "dirsh: Source environment for '$PWD'? [y/N] "
  read -r response

  case "$response" in
  [Yy]*)
    _set_dir_approval true
    return 0
    ;;
  *)
    _set_dir_approval false
    return 1
    ;;
  esac
}

_dirsh_hook() {
  _debug "$DIRSH_ACTIVE_ENV -> $PWD"

  # Check if moving up (not into a subdirectory)
  if [[ -n "$DIRSH_ACTIVE_ENV" && ! "$PWD" =~ ^"$DIRSH_ACTIVE_ENV"(/|$) ]]; then
    _print "Unloading..."

    _call_func _unload

    unset -f _load &>/dev/null
    unset -f _unload &>/dev/null

    unset DIRSH_ACTIVE_ENV
  fi

  if [[ -f "$PWD/$DIRSH_ENV_FILE" && -z "$DIRSH_ACTIVE_ENV" ]]; then
    _should_ask_to_load
    local exit_code=$?

    _debug "_should_ask_to_load: $exit_code"
    case $exit_code in
    40) ;;
    20)
      _print "dirsh not allowed"
      return
      ;;
    10 | 30)
      _prompt_for_approval || return
      ;;
    esac

    _print "Loading $DIRSH_ENV_FILE"

    source "$PWD/$DIRSH_ENV_FILE" &>/dev/null

    _call_func _load

    DIRSH_ACTIVE_ENV="$PWD"
    export DIRSH_ACTIVE_ENV
  fi
}

dirsh_load() {
  local dir=${1-$PWD}

  _print "Loading $DIRSH_ENV_FILE"

  source "$dir/$DIRSH_ENV_FILE" &>/dev/null

  _call_func _load

  DIRSH_ACTIVE_ENV="$dir"
  export DIRSH_ACTIVE_ENV
}

dirsh_reset_directory() {
  local dir=${1-$PWD}
  local tmp_file="${DIRSH_APPROVAL_FILE}.tmp"

  _debug "Resetting '$dir'"
  _debug "$DIRSH_APPROVAL_FILE"
  case "$DIRSH_CONFIG_FORMAT" in
  json)
    jq --arg dir "$dir" '.approved_dirs[$dir] = {}' \
      "$DIRSH_APPROVAL_FILE" >"$tmp_file" && mv "$tmp_file" "$DIRSH_APPROVAL_FILE"
    ;;
  yaml)
    yq 'del(.approved_dirs["'"$dir"'"])' \
      "$DIRSH_APPROVAL_FILE" >"$tmp_file" && mv "$tmp_file" "$DIRSH_APPROVAL_FILE"
    ;;
  esac
}

typeset -ag precmd_functions

if [[ -z ${precmd_functions[_dirsh_hook]} ]]; then
  precmd_functions+=_dirsh_hook
fi

# GistID: 87c59acf3b53cf1911bc6e3a8055afbf
# vim: ft=bash ts=2 sts=2 sw=2 et
