source "$XDG_CONFIG_HOME/zsh/.zshenv"

source "$XDG_CONFIG_HOME/alias.sh"
source "$XDG_CONFIG_HOME/rust.alias.sh"
source "$XDG_CONFIG_HOME/path.sh"

source <(op completion bash)

eval "$(starship init bash)"
