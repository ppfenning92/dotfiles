# Dotfiles

## setup new machine
### checkout repository
```shell
sudo apt install git -y
git config --global core.autocrlf false
mkdir -vp ~/.dotfiles
alias dotfiles="git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
dotfiles init -b main
dotfiles remote add origin https://github.com/ppfenning92/dotfiles.git
dotfiles fetch --all
dotfiles checkout -f main
dotfiles reset --hard
source .config/.env



```
### install ansible
```shell
./.local/bin/ansible-playbook setup/init.yml --ask-become-pass
```
