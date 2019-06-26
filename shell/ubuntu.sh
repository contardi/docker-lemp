#!/bin/bash

#Script to install Docker in Ubuntu machines with right permission
sudo apt-get update
sudo apt-get remove -y docker docker-engine docker.io docker-compose

sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

sudo snap install docker

sudo usermod -aG docker $USER
sudo usermod -aG www-data $USER

#Reload group preferences
su - $USER

#Download docker-compose
sudo curl -L https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

#Prepare for Elasticsearch
sudo sysctl -w vm.max_map_count=262144
sudo sysctl -w fs.file-max=65535
