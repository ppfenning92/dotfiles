# Dotfiles

```shell
#!/usr/bin/env sh

PROJECT_PATH=$(git rev-parse --show-toplevel)
bash -c $PROJECT_PATH/.githooks/pre-commit
```
