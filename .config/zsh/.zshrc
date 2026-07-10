# vim: ts=2 sts=2 sw=2 et ft=bash

ZSH_THEME=""
# ZSH_CUSTOM=/path/to/new-custom-folder

zstyle ':omz:update' mode reminder # just remind me to update when it's time

# autoload -U +X bashcompinit && bashcompinit
# autoload -Uz compinit && compinit -C

setopt append_history
setopt inc_append_history
setopt hist_ignore_space
setopt hist_reduce_blanks

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

[[ -r "$XDG_CONFIG_HOME/path.sh" ]] && source "$XDG_CONFIG_HOME/path.sh"

if [[ -z ${SYSTEM_TYPE} ]]; then
  # dev plugins
  plugins+=(
    gh
    tmux
    helm
    kubectl
    ansible
    docker
    # nvm
    # gcloud
    terraform
    aws
    # turv
  )
  zstyle ':omz:plugins:nvm' lazy yes
  zstyle ':omz:plugins:nvm' autoload yes
fi

[[ -r "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"

if [[ "$(uname -s)" == "Darwin" && -r "$XDG_CONFIG_HOME/macos.alias.sh" ]]; then
  source "$XDG_CONFIG_HOME/macos.alias.sh"
fi
[[ -r "$XDG_CONFIG_HOME/alias.sh" ]] && source "$XDG_CONFIG_HOME/alias.sh"
[[ -r "$XDG_CONFIG_HOME/rust.alias.sh" ]] && source "$XDG_CONFIG_HOME/rust.alias.sh"
[[ -r "$XDG_CONFIG_HOME/zsh/mise.zsh" ]] && source "$XDG_CONFIG_HOME/zsh/mise.zsh"
[[ -r "$XDG_CONFIG_HOME/zsh/secrets.zsh" ]] && source "$XDG_CONFIG_HOME/zsh/secrets.zsh"

if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  source "$NVM_DIR/nvm.sh"
elif command -v brew >/dev/null 2>&1; then
  nvm_homebrew_prefix="$(brew --prefix nvm 2>/dev/null)"
  if [[ -n "$nvm_homebrew_prefix" && -s "$nvm_homebrew_prefix/nvm.sh" ]]; then
    source "$nvm_homebrew_prefix/nvm.sh"
  fi
  unset nvm_homebrew_prefix
fi

[[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"

if command -v op 1>/dev/null; then
  eval "$(op completion zsh)"
  command -v compdef >/dev/null 2>&1 && compdef _op op
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
  local profile_file="$XDG_CONFIG_HOME/private.env"

  if [[ "$(uname -s)" == "Darwin" ]] && command -v ifconfig >/dev/null 2>&1; then
    if ifconfig -L utun4 >/dev/null 2>&1 || ifconfig -L utun100 >/dev/null 2>&1; then
      profile_file="$XDG_CONFIG_HOME/work.env"
    fi
  fi

  [[ -r "$profile_file" ]] && source "$profile_file"
}

precmd_functions+=(_fix_cursor _autoload_profile)

# source "$ZDOTDIR/dirsh.sh"

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init --cmd cd zsh)"
fi

if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

[[ -r "$HOME/.local/share/../bin/env" ]] && . "$HOME/.local/share/../bin/env"
