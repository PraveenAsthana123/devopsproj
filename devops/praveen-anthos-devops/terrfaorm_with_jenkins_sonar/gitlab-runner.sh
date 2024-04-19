#!/bin/bash

export GITLAB_REGISTRATION_TOKEN=GR1348941U7NzE11io2zpQzyChkdS

if [ -e /usr/bin/gitlab-runner ]; then
    echo "Gitlab Runner already installed"
else
    curl -LJO "https://gitlab-runner-downloads.s3.amazonaws.com/latest/deb/gitlab-runner_amd64.deb"
    sudo dpkg -i gitlab-runner_amd64.deb
    gitlab-runner -v
fi


if [ -e /usr/bin/docker ]; then
    echo "Docker Machine already installed:"
else
    sudo apt-get update -y
    sudo apt install docker.io -y
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo chmod 666 /var/run/docker.sock
    sudo systemctl restart docker
fi


sudo gitlab-runner register -n \
  --url https://gitlab.com/ \
  --registration-token $GITLAB_REGISTRATION_TOKEN \
  --executor shell \
  --description "gitlab-runner-$(hostname)-$(date +%N)" \
  --tag-list linux,shell

sudo usermod -aG docker gitlab-runner