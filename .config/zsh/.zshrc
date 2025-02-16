# vim: ts=2 sts=2 sw=2 et ft=bash

ZSH_THEME=""
# ZSH_CUSTOM=/path/to/new-custom-folder

zstyle ':omz:update' mode reminder # just remind me to update when it's time

# autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit -C

COMPLETION_WAITING_DOTS="true"

# see 'man strftime' for details.
HIST_STAMPS="yyyy-mm-dd"

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-completions
  zsh-vi-mode
  zsh-defer
)

source "$XDG_CONFIG_HOME/path.sh"

if [[ -z ${SYSTEM_TYPE} ]]; then
  # dev plugins
  plugins+=(
    gh
    tmux
    helm
    kubectl
    ansible
    docker
    nvm
    # gcloud
    terraform
    aws
    turv
  )
  zstyle ':omz:plugins:nvm' lazy yes
  zstyle ':omz:plugins:nvm' autoload yes
fi

source $ZSH/oh-my-zsh.sh

source "$XDG_CONFIG_HOME/alias.sh"
source "$XDG_CONFIG_HOME/rust.alias.sh"

zsh-defer source $(brew --prefix nvm)/nvm.sh

if [[ -f $(brew --prefix autoenv)/activate.sh ]]; then
  echo "cd? $AUTOENV_PRESERVE_CD"
  source $(brew --prefix autoenv)/activate.sh
  # autoload -U add-zsh-hook
  # setup_autoenv () {
  #   echo "###### $PWD"
  #  autoenv_init "$PWD"
  # }
  # add-zsh-hook chpwd setup_autoenv
fi

if command -v op 1>/dev/null; then
  eval "$(op completion zsh)"
  compdef _op op
fi

if command -v glab 1>/dev/null; then
  source <(/opt/homebrew/bin/glab completion -s zsh)
  compdef _glab glab
fi

if command -v flux 1>/dev/null; then
  flux() {

    unfunction "$0"
    . <(flux completion zsh)
    $0 "$@"
  }
fi

# bun completions
[ -s "$XDG_DATA_HOME"/bun/_bun ] && source "$XDG_DATA_HOME"/bun/_bun

[ -f "$XDG_CONFIG_HOME"/fzf/fzf.zsh ] && source "$XDG_CONFIG_HOME"/fzf/fzf.zsh

_fix_cursor() {
  echo -ne '\e[5 q'
}
_autoload_profile() {
  if ifconfig -L utun4 >/dev/null 2>&1; then
    . $XDG_CONFIG_HOME/work.env
  else
    . $XDG_CONFIG_HOME/private.env
  fi
}

precmd_functions+=(_fix_cursor _autoload_profile)

# setopt complete_aliases
setopt append_history
setopt inc_append_history
setopt hist_ignore_space
setopt hist_reduce_blanks

# source "$ZDOTDIR/dirsh.sh"

eval "$(zoxide init --cmd cd zsh)"

eval "$(starship init zsh)"
