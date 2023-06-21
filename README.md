# Dotfiles


## Repo setup
```shell
git config --local include.path ../.gitconfig 
```
## Encrypt/decrypt *.env files
```shell
find . -type f -iname "*.env" -exec sh -c "op item get ansible-vault --fields password | ansible-vault encrypt {} --vault-password-file=/bin/cat" \; 
find . -type f -iname "*.env" -exec sh -c "op item get ansible-vault --fields password | ansible-vault decrypt {} --vault-password-file=/bin/cat" \; 
```

 
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
