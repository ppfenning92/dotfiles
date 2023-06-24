source $HOME/.config/global.env

source $XDG_CONFIG_HOME/private.env
source $XDG_CONFIG_HOME/work.env


export HISTFILE="$XDG_STATE_HOME/zsh/history"
if [ ! -f "$HISTFILE" ]; then
  mkdir -p $XDG_STATE_HOME/state/zsh/
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

export AZURE_CONFIG_DIR="$XDG_DATA_HOME"/azure

export AWS_SHARED_CREDENTIALS_FILE="$XDG_CONFIG_HOME"/aws/credentials
export AWS_CONFIG_FILE="$XDG_CONFIG_HOME"/aws/config

. "/home/p/.local/share/cargo/env"

