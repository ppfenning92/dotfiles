# Dotfiles


## Repo setup
```shell
git config --local include.path ../dotfiles-gitconfig 
```

### install ansible
```shell
./.local/bin/ansible-playbook setup/init.yml --ask-become-pass
```
