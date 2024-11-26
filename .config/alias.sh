alias wget='wget --hsts-file="$XDG_DATA_HOME/wget-hsts"'

if [ -x "$(command -v nvim)" ]; then 
    alias vim="nvim"
    alias v="nvim"
    export GIT_EDITOR="nvim"
fi

alias s=". ~/.config/zsh/.zshrc && . ~/.config/zsh/.zshenv"

alias json="jq | cat -l json"

alias c="curl -L --silent"
alias t="tmux"


alias shell-keys="curl -s 'https://gist.githubusercontent.com/2KAbhishek/9c6d607e160b0439a186d4fbd1bd81df/raw/244284c0b3e40b2b67697665d2d61e537e0890fc/Shell_Keybindings.md'  | PAGER='bat --plain'; glow"

objectid ()
{
  local date=$(date +%s)

  local dateHex="$(printf '%x' $date)"
  local random16Hex="$(head -c 1000 /dev/urandom | tr -dc 'a-f0-9' | head -c16)"
  echo "$dateHex$random16Hex"
}

alias update="sudo apt update && sudo apt upgrade -y && sudo apt dist-upgrade && sudo apt autoremove -y && sudo apt autoclean"

git-new-init ()
{
  if [ -z ${1+x} ]; then echo "No branch provided"; return; fi
  b=$1;
  h="$(git rev-parse $b)";
  echo "Current branch: $b $h";
  c="$(git rev-parse $b~0)";
  echo "Recreating $b branch with initial commit $c ...";
  git checkout --orphan new-start $c;
  git commit -C $c;
  git rebase --onto new-start $c $b;
  git branch -d new-start; 
  git gc;
}

office-lights() {
  if [[ $1 == 'up' ]]; then
    curl "https://hass.local.j-p.cloud/api/webhook/p_workstation-up";
    return;
  elif [[ $1 == 'down' ]]; then
     curl "https://hass.local.j-p.cloud/api/webhook/p_workstation-down";
     return;
  else
    echo "unknown command '${1-none}'"
  fi

}
