# vim: ts=2 sts=2 sw=2 et ft=zsh

# Bootstrap OP_SERVICE_ACCOUNT_TOKEN from file in headless environments (VMs).
# On desktops the 1Password app handles auth — this is a no-op there.
() {
  local token_file="${OP_SERVICE_ACCOUNT_TOKEN_FILE:-$XDG_CONFIG_HOME/op/service-account-token}"
  if [[ -z "${OP_SERVICE_ACCOUNT_TOKEN:-}" && -r "$token_file" ]]; then
    export OP_SERVICE_ACCOUNT_TOKEN="$(<"$token_file")"
  fi
}

# Wrap tools that consume op:// env vars — op run resolves references at invocation time.
tofu()       { op run -- tofu "$@" }
terraform()  { op run -- terraform "$@" }
terragrunt() { op run -- terragrunt "$@" }
gh()         { op run -- gh "$@" }
glab()       { op run -- glab "$@" }

npm() {
  case "${1:-}" in
    publish|token|access|profile) op run -- npm "$@" ;;
    *)                            command npm "$@" ;;
  esac
}

pnpm() {
  case "${1:-}" in
    publish) op run -- pnpm "$@" ;;
    *)       command pnpm "$@" ;;
  esac
}

alias tf='terraform'
alias tg='terragrunt'
alias gl='glab'

# --- terragrunt shortcuts (git-alias style) ---
# Single unit (current dir) via `run --`. `o` = use the branch plan file.
alias tgi='terragrunt run -- init'
alias tgir='terragrunt run -- init -reconfigure -upgrade'
alias tgp='terragrunt run -- plan'
alias tgpo='terragrunt run -- plan -out="$(git_current_branch_clean).tfplan"'
alias tgy='terragrunt run -- apply'
alias tgyo='terragrunt run -- apply "$(git_current_branch_clean).tfplan"'
alias tgd='terragrunt run -- destroy'
alias tgv='terragrunt run -- validate'
alias tgo='terragrunt run -- output'
alias tgsl='terragrunt run -- state list'
alias tgss='terragrunt run -- state show'
alias tgfu='terragrunt run -- force-unlock'

# Whole stack via `run --all`; `a` = all. plan/apply piped through tgfilter.
# Functions so extra flags land before the pipe.
tga()    { terragrunt run --all -- "$@" }                                              # generic all runner
tgai()   { terragrunt run --all -- init -reconfigure -upgrade "$@" }
tgap()   { terragrunt run --all -- plan "$@" | tgfilter }
tgapo()  { terragrunt run --all -- plan -out="$(git_current_branch_clean).tfplan" "$@" | tgfilter }
tgaa()   { terragrunt run --all -- apply "$@" | tgfilter }

# Whole stack, affected units only (`run --all --filter-affected`).
tgaf()   { terragrunt run --all --filter-affected -- "$@" }                            # generic affected runner
tgafp()  { terragrunt run --all --filter-affected -- plan "$@" | tgfilter }
tgafpo() { terragrunt run --all --filter-affected -- plan -out="$(git_current_branch_clean).tfplan" "$@" | tgfilter }
tgafa()  { terragrunt run --all --filter-affected -- apply "$@" | tgfilter }

if (( $+functions[compdef] )); then
  (( $+functions[_terraform] )) && compdef _terraform terraform tf
  (( $+functions[_terragrunt] )) && compdef _terragrunt terragrunt tg
  (( $+functions[_tofu] )) && compdef _tofu tofu
  (( $+functions[_gh] )) && compdef _gh gh
  (( $+functions[_glab] )) && compdef _glab glab gl
  (( $+functions[_npm] )) && compdef _npm npm
  (( $+functions[_pnpm] )) && compdef _pnpm pnpm
  (( $+functions[_mise] )) && compdef _mise mise
  (( $+functions[_op] )) && compdef _op op
fi
