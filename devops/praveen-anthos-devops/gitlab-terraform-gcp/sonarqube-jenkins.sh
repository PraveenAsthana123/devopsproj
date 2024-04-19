#!/bin/bash

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

echo "using docker for jenkins"
sudo docker run -d --name jenkins -p 8080:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts-jdk11


echo "using docker for sonarqube"
sudo docker container run -d -p 9000:9000 --name sonarserver sonarqube:8.2-community

sudo docker ps