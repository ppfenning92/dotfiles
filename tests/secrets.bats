#!/usr/bin/env bats

setup() {
  unset GITLAB_TOKEN TF_VAR_cloudflare_api_token NPM_TOKEN CLOUDFLARE_API_TOKEN
  unset EXPECT_GITLAB_TOKEN EXPECT_TF_VAR_CLOUDFLARE_API_TOKEN EXPECT_NPM_TOKEN EXPECT_NO_NPM_TOKEN EXPECT_NO_OP_SERVICE_ACCOUNT_TOKEN
  export TEST_TMPDIR="$BATS_TEST_TMPDIR"
  export PATH="$TEST_TMPDIR/bin:$PATH"
  mkdir -p "$TEST_TMPDIR/bin" "$TEST_TMPDIR/project"

  cat >"$TEST_TMPDIR/bin/assert-env" <<'EOF'
#!/usr/bin/env sh
set -eu

if [ -n "${EXPECT_GITLAB_TOKEN+x}" ]; then
  [ "${GITLAB_TOKEN-}" = "$EXPECT_GITLAB_TOKEN" ] || exit 10
fi

if [ -n "${EXPECT_TF_VAR_CLOUDFLARE_API_TOKEN+x}" ]; then
  [ "${TF_VAR_cloudflare_api_token-}" = "$EXPECT_TF_VAR_CLOUDFLARE_API_TOKEN" ] || exit 11
fi

if [ -n "${EXPECT_NPM_TOKEN+x}" ]; then
  [ "${NPM_TOKEN-}" = "$EXPECT_NPM_TOKEN" ] || exit 12
fi

if [ -n "${EXPECT_NO_NPM_TOKEN+x}" ]; then
  [ -z "${NPM_TOKEN-}" ] || exit 13
fi

if [ -n "${EXPECT_NO_OP_SERVICE_ACCOUNT_TOKEN+x}" ]; then
  [ -z "${OP_SERVICE_ACCOUNT_TOKEN-}" ] || exit 14
fi

echo ok
EOF
  chmod +x "$TEST_TMPDIR/bin/assert-env"

  for cmd in tofu terraform terragrunt gh glab npm pnpm; do
    ln -s assert-env "$TEST_TMPDIR/bin/$cmd"
  done
}

skip_without_op_account() {
  command -v op >/dev/null 2>&1 || skip "op CLI is not installed"
  op whoami >/dev/null 2>&1 || skip "op CLI is not signed in"
}

@test "missing env file falls back to the original command without op" {
  run zsh -f -c "cd '$TEST_TMPDIR/project'; source '$PWD/.config/zsh/secrets.zsh'; tofu"

  [ "$status" -eq 0 ]
  [ "$output" = "ok" ]
}

@test "wrappers keep secrets out of the idle shell" {
  cat >"$TEST_TMPDIR/project/.env.op" <<'EOF'
GITLAB_TOKEN=dummy-gitlab-token
TF_VAR_cloudflare_api_token=dummy-cloudflare-token
EOF

  run zsh -f -c "cd '$TEST_TMPDIR/project'; source '$PWD/.config/zsh/secrets.zsh'; printenv GITLAB_TOKEN || true"

  [ "$status" -eq 0 ]
  [ -z "$output" ]
}

@test "real op run injects .env.op values only into the subprocess" {
  skip_without_op_account

  cat >"$TEST_TMPDIR/project/.env.op" <<'EOF'
GITLAB_TOKEN=dummy-gitlab-token
TF_VAR_cloudflare_api_token=dummy-cloudflare-token
EOF

  run zsh -f -c "cd '$TEST_TMPDIR/project'; source '$PWD/.config/zsh/secrets.zsh'; EXPECT_GITLAB_TOKEN=dummy-gitlab-token EXPECT_TF_VAR_CLOUDFLARE_API_TOKEN=dummy-cloudflare-token EXPECT_NO_OP_SERVICE_ACCOUNT_TOKEN=1 terraform"

  [ "$status" -eq 0 ]
  [ "$output" = "ok" ]
}

@test "OP_ENV_FILE points wrappers at the project secret reference file" {
  skip_without_op_account

  cat >"$TEST_TMPDIR/project/custom.env" <<'EOF'
GITLAB_TOKEN=dummy-from-custom-env
EOF

  run zsh -f -c "source '$PWD/.config/zsh/secrets.zsh'; OP_ENV_FILE='$TEST_TMPDIR/project/custom.env' EXPECT_GITLAB_TOKEN=dummy-from-custom-env EXPECT_NO_OP_SERVICE_ACCOUNT_TOKEN=1 gh"

  [ "$status" -eq 0 ]
  [ "$output" = "ok" ]
}

@test "npm wraps secret-bearing commands only" {
  skip_without_op_account

  cat >"$TEST_TMPDIR/project/.env.op" <<'EOF'
NPM_TOKEN=dummy-npm-token
EOF

  run zsh -f -c "cd '$TEST_TMPDIR/project'; source '$PWD/.config/zsh/secrets.zsh'; EXPECT_NO_NPM_TOKEN=1 npm install && EXPECT_NPM_TOKEN=dummy-npm-token EXPECT_NO_OP_SERVICE_ACCOUNT_TOKEN=1 npm publish"

  [ "$status" -eq 0 ]
  [ "$output" = $'ok
ok' ]
}

@test "pnpm wraps publish only" {
  skip_without_op_account

  cat >"$TEST_TMPDIR/project/.env.op" <<'EOF'
NPM_TOKEN=dummy-pnpm-token
EOF

  run zsh -f -c "cd '$TEST_TMPDIR/project'; source '$PWD/.config/zsh/secrets.zsh'; EXPECT_NO_NPM_TOKEN=1 pnpm install && EXPECT_NPM_TOKEN=dummy-pnpm-token EXPECT_NO_OP_SERVICE_ACCOUNT_TOKEN=1 pnpm publish"

  [ "$status" -eq 0 ]
  [ "$output" = $'ok
ok' ]
}

@test "recommended direnv setup exports only the OP_ENV_FILE path" {
  run grep -q 'direnv_load op run' .envrc.example .config/direnv/direnvrc
  [ "$status" -ne 0 ]

  run grep -q '^use_project_env$' .envrc.example
  [ "$status" -eq 0 ]

  run grep -q 'export OP_ENV_FILE="$PWD/.env.op"' .config/direnv/direnvrc
  [ "$status" -eq 0 ]
}
