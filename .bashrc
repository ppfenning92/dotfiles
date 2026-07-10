[[ -r "$XDG_CONFIG_HOME/zsh/.zshenv" ]] && source "$XDG_CONFIG_HOME/zsh/.zshenv"
export HISTFILE="${XDG_STATE_HOME}/bash/history"
[[ -d "${XDG_STATE_HOME}/bash" ]] || mkdir -p "${XDG_STATE_HOME}/bash"

[[ -r "$XDG_CONFIG_HOME/path.sh" ]] && source "$XDG_CONFIG_HOME/path.sh"
[[ -r "$XDG_CONFIG_HOME/alias.sh" ]] && source "$XDG_CONFIG_HOME/alias.sh"
[[ -r "$XDG_CONFIG_HOME/rust.alias.sh" ]] && source "$XDG_CONFIG_HOME/rust.alias.sh"

[[ -r "$XDG_CONFIG_HOME/bash/mise.bash" ]] && source "$XDG_CONFIG_HOME/bash/mise.bash"
[[ -r "$XDG_CONFIG_HOME/bash/direnv.bash" ]] && source "$XDG_CONFIG_HOME/bash/direnv.bash"

if command -v op >/dev/null 2>&1; then
  source <(op completion bash)
fi
[ -f "$XDG_CONFIG_HOME"/fzf/fzf.bash ] && source "$XDG_CONFIG_HOME"/fzf/fzf.bash
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init bash)"
fi

if command -v starship >/dev/null 2>&1; then
  eval "$(starship init bash)"
fi

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

[[ -r "$HOME/.local/share/../bin/env" ]] && . "$HOME/.local/share/../bin/env"
