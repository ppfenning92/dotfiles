# vim: ts=2 sts=2 sw=2 et ft=bash

source $HOME/.config/global.env

export HISTFILE="$XDG_STATE_HOME/zsh/history"
if [ ! -f "$HISTFILE" ]; then
  mkdir -p $XDG_STATE_HOME/zsh/
  touch $HISTFILE
fi

export WAKATIME_HOME="$XDG_CONFIG_HOME/wakatime"
if [ ! -d "$WAKATIME_HOME" ]; then
  mkdir -p $WAKATIME_HOME
fi

export VAGRANT_HOME="$XDG_DATA_HOME"/vagrant

export PYLINTHOME="$XDG_CACHE_HOME"/pylint
export PYENV_ROOT="$XDG_DATA_HOME"/pyenv

export NVM_DIR="$XDG_DATA_HOME"/nvm
export NODE_REPL_HISTORY="$XDG_DATA_HOME"/node_repl_history
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME"/npm/npmrc

export LESSHISTFILE="$XDG_STATE_HOME"/less/history

export GOPATH="$XDG_DATA_HOME"/go

export GNUPGHOME="$XDG_DATA_HOME"/gnupg

export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker

export MINIKUBE_HOME="$XDG_DATA_HOME"/minikube

export KUBECONFIG="$HOME/.kube/config/rke2.yaml"
export KREW_ROOT="$XDG_DATA_HOME/krew"
export AZURE_CONFIG_DIR="$XDG_DATA_HOME"/azure

export AWS_SHARED_CREDENTIALS_FILE="$XDG_CONFIG_HOME"/aws/credentials
export AWS_CONFIG_FILE="$XDG_CONFIG_HOME"/aws/config
export AWS_DEFAULT_OUTPUT="yaml"
export AWS_DEFAULT_REGION="eu-central-1"
export AWS_PAGER="bat -lyaml --style plain"

if [[ -n "$SSH_CLIENT" || -n "$SSH_TTY" ]]; then
  export ZSH_TMUX_AUTOSTART=false
  export ZSH_TMUX_AUTOCONNECT=false
  export ZSH_TMUX_AUTOQUIT=false
else
  export ZSH_TMUX_AUTOSTART=true
  export ZSH_TMUX_AUTOCONNECT=false
  export ZSH_TMUX_AUTOQUIT=false
fi
export WORKON_HOME="$XDG_DATA_HOME/virtualenvs"
export KERAS_HOME="$XDG_STATE_HOME/keras"
export CUDA_CACHE_PATH="$XDG_CACHE_HOME"/nv
export ANSIBLE_HOME="$XDG_DATA_HOME"/ansible

export TS_NODE_HISTORY="$XDG_STATE_HOME"/ts_node_repl_history
export BUN_INSTALL="$XDG_DATA_HOME"/bun
export DOTNET_CLI_HOME="$XDG_DATA_HOME"/dotnet
export ANDROID_USER_HOME="$XDG_DATA_HOME"/android
export ANSIBLE_HOME="$XDG_DATA_HOME"/ansible

export GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java

export _ZO_ECHO=""

# TURV CONFIG
export TURV_VIEWER="bat -lbash --style=snip,numbers,header"
export TURV_DEBUG=""
export TURV_CONFIG_FORMAT="yaml"

# nb https://github.com/xwmx/nb
export NB_DIR="$XDG_STATE_HOME/nb"
export NBRC_PATH="$XDG_CONFIG_HOME/nb/nbrc"
export NB_ENCRYPTION_TOOL=gpg
export NB_BROWSE_MARKDOWN_READER=glow
