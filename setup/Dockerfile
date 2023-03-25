FROM ubuntu:22.04

ENV USER=p

# update
RUN apt update -qqq && apt upgrade -y && apt dist-upgrade -y
RUN apt install sudo openssl
# add user
RUN useradd -ms /bin/bash $USER
RUN PASS=$(openssl rand -hex 12) && \
    echo $PASS && \
    echo "${USER}:${PASS}" | chpasswd
RUN usermod -aG sudo $USER

USER $USER

WORKDIR /home/$USER

