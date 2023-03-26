# Dotfiles

## setup new maschine
```shell
sudo apt install git -y
mkdir -vp ~/dotfiles
alias dotfiles="git --git-dir=$HOME/dotfiles/ --work-tree=$HOME"
dotfiles init
dotfiles remote add origin https://github.com/ppfenning92/dotfiles.git
dotfiles fetch --all
dotfiles checkout main
dotfiles reset --hard
./.scripts/init.sh



```
