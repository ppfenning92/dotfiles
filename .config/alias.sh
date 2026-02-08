alias update="sudo apt update && sudo apt upgrade -y && sudo apt dist-upgrade && sudo apt autoremove -y && sudo apt autoclean"
alias wget='wget --hsts-file="$XDG_DATA_HOME/wget-hsts"'

if [ -x "$(command -v nvim)" ]; then
  alias v="nvim"
  export GIT_EDITOR="nvim"
  export EDITOR="nvim"
  export ZSH_VI_EDITOR="nvim"
  vim() {
    APPS=()
    for NVIM_DIR in $XDG_CONFIG_HOME/nvim*; do
      APP=$(basename "$NVIM_DIR")
      APPS+=(${APP/nvim-/})
      echo "$NVIM_DIR - $APP [ $APPS ]"
    done
    select config in $APPS; do
      echo $config
      if [[ $config != nvim ]]; then
        NVIM_APPNAME=nvim-$config nvim $@
        break
      else
        nvim $@
        break
      fi
    done
  }
fi

alias s=". ~/.config/zsh/.zshenv && . ~/.config/zsh/.zshrc"

alias json="jq | cat -l json"
alias c="curl -L --silent"
alias t="tmux"

if type -p glab 1>/dev/null; then
  source <(/opt/homebrew/bin/glab completion -s zsh)
  compdef _glab glab
<<<<<<< HEAD
  complete -C /opt/homebrew/bin/glab glab
  alias gl="_gl"
  compdef _glab _gl
fi

function _gl() {
  op run -- glab "$@"
}
=======

  function _gl() {
    op run -- glab "$@"
    # op plugin run -- glab "$@"
  }
  complete -C /opt/homebrew/bin/glab glab
  alias gl="_gl"
  alias glmr="gl mr create --squash-before-merge --remove-source-branch --target-branch=\"\$(git_main_branch)\" --assignee=\"patrick.pfenning\" --description=''"
  compdef _glab _gl
fi
>>>>>>> 3550f169265fe6159432c19ce94891fec142395d

alias glmr="gl mr create --squash-before-merge --remove-source-branch --target-branch=\"\$(git_main_branch)\" --assignee=\"patrick.pfenning\" --description=''"
alias shell-keys="curl -s 'https://gist.githubusercontent.com/2KAbhishek/9c6d607e160b0439a186d4fbd1bd81df/raw/244284c0b3e40b2b67697665d2d61e537e0890fc/Shell_Keybindings.md'  | PAGER='bat --plain'; glow"
# alias ip-info="ip -json a | jq -r '.[] | \"\(.ifname) \(select(.addr_info != null) | .addr_info[] | select(.family == \"inet\") | \"\(.local)/\(.prefixlen)\" )\"' | column -t -s' '"
#
if command -v terraform 1>/dev/null; then
  complete -C /opt/homebrew/bin/terraform terraform
  alias tf="_tf"
  compdef _terraform _tf
fi

if command -v terragrunt 1>/dev/null; then
  complete -C /opt/homebrew/bin/terragrunt terragrunt
  alias tg="_tg"
  compdef terragrunt _tg
  # terragrunt --install-autocomplete
fi

function _tg() {
  op run -- terragrunt "$@"
}

function _tf() {
  op run -- terraform "$@"
}

wmip() {
  https "http://api.ipapi.com/api?access_key=$(op read "op://Private/IPAPI/API/access_key")"
}

ipinfo() {
  local interfaces
  interfaces=$(ip -json a | jq -r '.[] | "\(.ifname) \(select(.addr_info != null) | .addr_info[] | select(.family == "inet") | "\(.local)/\(.prefixlen)" )"')

  local extip
  extip="$(curl -m1 --silent 'https://api.ipify.org?format=text')"

  cat <<EOF | column -t -s' '
$interfaces
wan $extip
EOF
}

objectid() {
  local date
  date="$(date +%s)"

  local dateHex
  dateHex="$(printf '%x' "$date")"

  local random16Hex
  random16Hex="$(head -c 1000 /dev/urandom | tr -dc 'a-f0-9' | head -c16)"
  echo "$dateHex$random16Hex"
}

git-new-init() {
  if [ -z ${1+x} ]; then
    echo "No branch provided"
    return
  fi
  b=$1
  h="$(git rev-parse "$b")"
  echo "Current branch: $b $h"
  c="$(git rev-parse "$b"~0)"
  echo "Recreating $b branch with initial commit $c ..."
  git checkout --orphan new-start "$c"
  git commit -C "$c"
  git rebase --onto new-start "$c" "$b"
  git branch -d new-start
  git gc
}

office-lights() {
  if [[ $1 == 'up' ]]; then
    curl "https://hass.local.j-p.cloud/api/webhook/p_workstation-up"
    return
  elif [[ $1 == 'down' ]]; then
    curl "https://hass.local.j-p.cloud/api/webhook/p_workstation-down"
    return
  else
    echo "unknown command '${1-none}'"
  fi
}

columns() {
  nu -c "cat | detect columns $@"
}

git_current_branch_clean() {
  local current_branch
  current_branch="$(git_current_branch)"
  local current_branch_clean
  current_branch_clean="$(echo -n "$current_branch" | tr -c '[:alnum:]' '_')"

  echo "$current_branch_clean"
}

sha-cmp() {
  FILE_1=$1
  FILE_2=$2

  if [[ ! -r "$FILE_1" ]]; then
    echo "$FILE_1 does not exist." >&2
    return 1
  fi

  if [[ ! -r "$FILE_2" ]]; then
    echo "$FILE_2 does not exist." >&2
    return 1
  fi

  HASH=$(sha256sum "$FILE_1" | sed 's/ .*//')
  echo "$HASH $FILE_2" | sha256sum --check
}

alias kuse="kubectl config use-context "
alias kns="kubectl config set-context --current --namespace "
alias kns-='kubectl config unset contexts.$(kubectl config current-context).namespace'

# --- Better file operations ---

# --- Simple and safe file operations ---

# Copy files or directories with progress and backup if overwriting
copy() {
  if [[ $# -lt 2 ]]; then
    echo "Usage: copy <source> <destination>"
    return 1
  fi
  local src="$1"
  local dst="$2"
  rsync -ah --info=progress2 --backup --suffix='.bak' "$src" "$dst"
}

# Move files or directories with progress and overwrite confirmation
move() {
  if [[ $# -lt 2 ]]; then
    echo "Usage: move <source> <destination>"
    return 1
  fi
  local src="$1"
  local dst="$2"

  if [[ -e "$dst" ]]; then
    read "resp?File '$dst' exists. Overwrite? [y/N] "
    [[ "$resp" =~ ^[Yy]$ ]] || {
      echo "Aborted."
      return 1
    }
  fi

  rsync -ah --info=progress2 ---backup --suffix='.bak' --remove-source-files "$src" "$dst"

  # Only cleanup directories if src is a directory
  if [[ -d "$src" ]]; then
    find "$src" -type d -empty -delete
  fi
}

# Delete files or directories with confirmation
delete() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: delete <file|directory>..."
    return 1
  fi
  echo "You are about to permanently delete: $@"
  read "resp?Proceed? [y/N] "
  [[ "$resp" =~ ^[Yy]$ ]] || {
    echo "Aborted."
    return 1
  }
  /bin/rm -rf "$@"
}

alias cp='echo "Use: copy <src> <dst>"; cp -i'
alias mv='echo "Use: move <src> <dst>"; mv -i'
alias rm='echo "Use: delete <file>".; rm -i'

on-login() {

  local user
  user="$(whoami)"

  netbird up 1>/dev/null
  echo "-- Connected to Netbird"

  local time_past
  time_past=0
  until netbird status --json | jq -e '(.dnsServers // []) | length > 0' >/dev/null 2>&1; do
    echo -ne "-- Waiting for nameservers... [elapsed time ${time_past}s]"\\r
    sleep 1
    ((time_past += 1))
  done

  echo ""

  netbird status --json | jq -r '
    .dnsServers[] |
      "## DNS Configs:\n - Servers: \((.servers // []) | join(", "))\n - Domains: \((.domains // []) | join(", "))"
  '

  time_past=0
  until [ -n "$(dig +short "vault.office.ottonova.de")" ]; do
    echo -ne "-- Waiting for DNS resolution... [elapsed time ${time_past}s]"\\r
    sleep 1
    ((time_past += 1))
  done
  echo ""
  echo "-- VPN booted."

  local vault_bin
  vault_bin=$(whence -p vault)
  export VAULT_ADDR="https://vault.office.ottonova.de"
  $vault_bin token renew 1>/dev/null
  RENEW_SUCCESS=$?

  if [[ ${RENEW_SUCCESS} -ne 0 ]]; then
    echo "--- Vault Login"
    $vault_bin login -method=ldap username=${user}
  fi

  echo "-- Logged int to vault"

  $vault_bin write -field=signed_key ssh/sign/admin public_key="@$HOME/.ssh/on_ed25519.pub" - <<"EOH" >"$HOME/.ssh/on_ed25519-cert.pub"
{
  "valid_principals": "ubuntu, core, admin, centos, rocky"
}
EOH

  echo "-- SSH key successfully signed"

  local token
  token="$(op read --account ottonova "op://Employee/gitlab.on.ag/token")"
  echo "-- Got GitLab token from 1Password"

  echo -n "$token" | podman login registry.on.ag -u ${user} --password-stdin 1>/dev/null
  echo -n "$token" | skopeo login registry.on.ag -u ${user} --password-stdin 1>/dev/null

  echo "-- Authenticated podman and skopeo against container registry"

  echo "-- Getting SSO session for AWS"
  aws sso login 1>/dev/null
}
