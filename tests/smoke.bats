#!/usr/bin/env bats
# Smoke tests: stow layout, config sources clean, core tools on PATH, XDG vars set.

@test "XDG_CONFIG_HOME is set" {
  [[ -n "$XDG_CONFIG_HOME" ]]
}

@test "XDG_DATA_HOME is set" {
  [[ -n "$XDG_DATA_HOME" ]]
}

@test "XDG_CACHE_HOME is set" {
  [[ -n "$XDG_CACHE_HOME" ]]
}

@test "XDG_STATE_HOME is set" {
  [[ -n "$XDG_STATE_HOME" ]]
}

@test "stow created .config symlink" {
  [[ -L "$HOME/.config" || -d "$HOME/.config" ]]
}

@test "alias.sh sources without error" {
  run bash -c "source '$XDG_CONFIG_HOME/alias.sh'"
  [ "$status" -eq 0 ]
}

@test "rust.alias.sh sources without error" {
  run bash -c "source '$XDG_CONFIG_HOME/rust.alias.sh'"
  [ "$status" -eq 0 ]
}

@test "path.sh sources without error" {
  run bash -c "source '$XDG_CONFIG_HOME/path.sh'"
  [ "$status" -eq 0 ]
}

@test "global.env sources without error" {
  run bash -c "source '$XDG_CONFIG_HOME/global.env'"
  [ "$status" -eq 0 ]
}

@test "mise is on PATH" {
  command -v mise >/dev/null 2>&1
}

@test "direnv is available via mise" {
  run mise exec -- direnv version
  [ "$status" -eq 0 ]
}

@test "git is available" {
  command -v git >/dev/null 2>&1
}

@test "zsh is available" {
  command -v zsh >/dev/null 2>&1
}

@test "stow is available" {
  command -v stow >/dev/null 2>&1
}
