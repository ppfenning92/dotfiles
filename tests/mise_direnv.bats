#!/usr/bin/env bats

setup() {
  unset GITLAB_TOKEN TF_VAR_cloudflare_api_token NPM_TOKEN CLOUDFLARE_API_TOKEN OP_ENV_FILE PROJECT_PUBLIC_VAR
  export TEST_TMPDIR="$BATS_TEST_TMPDIR"
  mkdir -p "$TEST_TMPDIR/project"

  if command -v mise >/dev/null 2>&1; then
    eval "$(mise activate bash)"
  fi
}

skip_without_mise() {
  command -v mise >/dev/null 2>&1 || skip "mise is not installed"
}

skip_without_direnv() {
  command -v direnv >/dev/null 2>&1 || skip "direnv is not installed"
}

@test "mise and direnv shell hooks are split by tool" {
  [ -f .config/zsh/mise.zsh ]
  [ -f .config/zsh/direnv.zsh ]
  [ -f .config/bash/mise.bash ]
  [ -f .config/bash/direnv.bash ]
  [ ! -e .config/zsh/mise-direnv.zsh ]
}

@test "mise manages direnv" {
  skip_without_mise

  run mise exec -- direnv version

  [ "$status" -eq 0 ]
  [[ "$output" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]
}

@test "direnv project helper exports public env and OP_ENV_FILE only" {
  skip_without_direnv

  cat >"$TEST_TMPDIR/project/.envrc" <<'EOF'
use_project_env
EOF
  cat >"$TEST_TMPDIR/project/.env.public" <<'EOF'
PROJECT_PUBLIC_VAR=visible
EOF
  cat >"$TEST_TMPDIR/project/.env.op" <<'EOF'
GITLAB_TOKEN=op://Private/Dummy/token
EOF

  cat >"$TEST_TMPDIR/project/assert-direnv" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
[ "${PROJECT_PUBLIC_VAR-}" = visible ]
[ "${OP_ENV_FILE-}" = "$PWD/.env.op" ]
[ -z "${GITLAB_TOKEN-}" ]
echo ok
EOF
  chmod +x "$TEST_TMPDIR/project/assert-direnv"

  run bash -c "cd '$TEST_TMPDIR/project' && DIRENV_LOG_FORMAT='' direnv allow . >/dev/null && env -u GITLAB_TOKEN -u TF_VAR_cloudflare_api_token -u NPM_TOKEN DIRENV_LOG_FORMAT='' direnv exec . ./assert-direnv"


  [ "$status" -eq 0 ]
  [[ "$output" == *"ok"* ]]
}
