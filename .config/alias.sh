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

if command -v glab 1>/dev/null; then
  source <(/opt/homebrew/bin/glab completion -s zsh)
  compdef _glab glab
fi

function _gl() {
  op plugin run -- glab "$@"
}
complete -C /opt/homebrew/bin/glab glab
alias gl="_gl"
alias glmr="gl mr create --squash-before-merge --remove-source-branch --target-branch=\"\$(git_main_branch)\" --assignee=\"patrick.pfenning\" --description=''"
compdef _glab _gl

alias shell-keys="curl -s 'https://gist.githubusercontent.com/2KAbhishek/9c6d607e160b0439a186d4fbd1bd81df/raw/244284c0b3e40b2b67697665d2d61e537e0890fc/Shell_Keybindings.md'  | PAGER='bat --plain'; glow"
alias ip-info="ip -json a | jq -r '.[] | \"\(.ifname) \(select(.addr_info != null) | .addr_info[] | select(.family == \"inet\") | \"\(.local)/\(.prefixlen)\" )\"' | column -t -s' '"

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

alias columns="nu -c 'cat | detect columns'"

git_current_branch_clean() {
  local current_branch
  current_branch="$(git_current_branch)"
  local current_branch_clean
  current_branch_clean="$(echo -n "$current_branch" | tr -c '[:alnum:]' '_')"

  echo "$current_branch_clean"
}
