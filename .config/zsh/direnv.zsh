# vim: ts=2 sts=2 sw=2 et ft=zsh

if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi
