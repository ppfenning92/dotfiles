# vim: ts=2 sts=2 sw=2 et ft=zsh

_op_service_account_env() {
  local token_file="${OP_SERVICE_ACCOUNT_TOKEN_FILE:-$XDG_CONFIG_HOME/op/service-account-token}"

  if [[ -n "${OP_SERVICE_ACCOUNT_TOKEN:-}" ]]; then
    OP_SERVICE_ACCOUNT_TOKEN="$OP_SERVICE_ACCOUNT_TOKEN" "$@"
  elif [[ -r "$token_file" ]]; then
    OP_SERVICE_ACCOUNT_TOKEN="$(<"$token_file")" "$@"
  else
    "$@"
  fi
}

_op_env_file() {
  local env_file="${OP_ENV_FILE:-.env.op}"

  if [[ -f "$env_file" ]] && command -v op >/dev/null 2>&1; then
    _op_service_account_env op run --env-file "$env_file" -- env -u OP_SERVICE_ACCOUNT_TOKEN "$@"
  else
    command "$@"
  fi
}

tofu() {
  _op_env_file tofu "$@"
}

terraform() {
  _op_env_file terraform "$@"
}

terragrunt() {
  _op_env_file terragrunt "$@"
}

gh() {
  _op_env_file gh "$@"
}

glab() {
  _op_env_file glab "$@"
}

npm() {
  case "${1:-}" in
    publish|token|access|profile)
      _op_env_file npm "$@"
      ;;
    *)
      command npm "$@"
      ;;
  esac
}

pnpm() {
  case "${1:-}" in
    publish)
      _op_env_file pnpm "$@"
      ;;
    *)
      command pnpm "$@"
      ;;
  esac
}

alias tf='terraform'
alias tg='terragrunt'
alias gl='glab'

if (( $+functions[compdef] )); then
  (( $+functions[_terraform] )) && compdef _terraform terraform tf
  (( $+functions[_terragrunt] )) && compdef _terragrunt terragrunt tg
  (( $+functions[_tofu] )) && compdef _tofu tofu
  (( $+functions[_gh] )) && compdef _gh gh
  (( $+functions[_glab] )) && compdef _glab glab gl
  (( $+functions[_npm] )) && compdef _npm npm
  (( $+functions[_pnpm] )) && compdef _pnpm pnpm
fi
