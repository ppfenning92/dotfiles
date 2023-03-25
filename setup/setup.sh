#!/bin/bash

set -e

sudo apt update -qqq && sudo apt -qqq -o Dpkg::Use-Pty=0 upgrade -y && sudo apt -qqq -o Dpkg::Use-Pty=0 dist-upgrade -y
sudo apt -qqq -o Dpkg::Use-Pty=0 install software-properties-common python3 python-is-python3 python3-pip -y

echo "export PATH=$PATH:$HOME/.local/bin" >> $HOME/.bashrc
pip install --no-warn-script-location --user ansible
# d92615e3fd2a83a68cfaa08a
