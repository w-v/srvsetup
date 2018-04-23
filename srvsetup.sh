#!/bin/bash
TRHOME=/home/transmission
TRCONFIG=${TRHOME}/config
TRDOWNLOADS=${TRHOME}/downloads
TRWATCH=${TRHOME}/watch
TRUID=1001
TRGID=1001

# Docker installation

echo "---------installing docker----------"

sudo apt-get -y remove docker docker-engine docker.io
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates wget software-properties-common
wget https://download.docker.com/linux/debian/gpg 
sudo apt-key add gpg
echo "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee -a /etc/apt/sources.list.d/docker.list
sudo apt-get update
sudo apt-cache policy docker-ce
sudo apt-get -y install docker-ce
sudo systemctl enable docker
sudo systemctl start docker
sudo systemctl status docker
sudo docker run hello-world

# Adding transmission user

echo "---------Adding transmission user----------"

sudo adduser --uid ${TRUID} --disabled-password --gecos "" transmission
sudo addgroup --gid ${TRGID} transmission

# making dirs

echo "---------making dirs----------"

sudo mkdir ${TRHOME} ${TRWATCH} ${TRDOWNLOADS} ${TRCONFIG} 
sudo chown ${TRUID}:${TRGID} ${TRHOME} ${TRWATCH} ${TRDOWNLOADS} ${TRCONFIG} 


# transmission container setup

echo "---------transmission container setup----------"

docker create --name=transmission \
-v ${TRCONFIG}:/config \
-v ${TRDOWNLOADS}:/downloads \
-v ${TRWATCH}:/watch \
-e PGID=${TRGID} -e PUID=${TRUID} \
-e TZ=Germany/Berlin \
-p 9091:9091 -p 51413:51413 \
-p 51413:51413/udp \
linuxserver/transmission
