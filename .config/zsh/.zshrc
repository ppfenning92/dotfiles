# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME=""


# CASE_SENSITIVE="true" # case-sensitive completion.
# HYPHEN_INSENSITIVE="true" # Case-sensitive completion must be off. _ and - will be interchangeable.

# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
COMPLETION_WAITING_DOTS="true"

# DISABLE_UNTRACKED_FILES_DIRTY="true"
 
# see 'man strftime' for details.
HIST_STAMPS="yyyy-mm-dd"

# ZSH_CUSTOM=/path/to/new-custom-folder

plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-completions
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
  )
  zstyle ':omz:plugins:nvm' lazy yes
  zstyle ':omz:plugins:nvm' autoload yes
fi

source $ZSH/oh-my-zsh.sh


# export MANPATH="/usr/local/man:$MANPATH"

source "$XDG_CONFIG_HOME/alias.sh"
source "$XDG_CONFIG_HOME/rust.alias.sh"

source $XDG_CONFIG_HOME/work.env
if command -v op 1>/dev/null; then
  eval "$(op completion zsh)"; compdef _op op
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

precmd_functions+=(_fix_cursor)

eval "$(zoxide init --cmd cd zsh)"

eval "$(starship init zsh)"

