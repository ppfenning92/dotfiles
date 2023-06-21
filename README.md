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
mkdir -vp ~/.cfg
alias cfg="git --git-dir=$HOME/.cfg/ --work-tree=$HOME"
cfg init -b main
cfg remote add origin git@github.com/ppfenning92/dotfiles.git
cfg fetch --all
cfg checkout -f main
cfg reset --hard
source .config/.env



```
### install ansible
```shell
./.local/bin/ansible-playbook setup/init.yml --ask-become-pass
```
