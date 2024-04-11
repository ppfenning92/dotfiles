alias wget=wget --hsts-file="$XDG_DATA_HOME/wget-hsts"

if [ -x "$(command -v nvim)" ]; then 
    alias vim="nvim"
    export GIT_EDITOR="nvim"
fi

alias s="source ~/.config/zsh/.zshrc"

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

alias up="sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y && sudo apt autoclean"
