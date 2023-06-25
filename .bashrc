source "$HOME/.config/global.env"

source "$XDG_CONFIG_HOME/private.env"
source "$XDG_CONFIG_HOME/work.env"


source "$XDG_CONFIG_HOME/rust.alias.sh"
source ""$XDG_CONFIG_HOME/path.sh"

source <(op completion bash)

eval "$(starship init zsh)"
