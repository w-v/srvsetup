#!/bin/bash
TRHOME = /home/dl
TRCONFIG = ${TRHOME}/config
TRDOWNLOADS = ${TRHOME}/downloads
TRWATCH = ${TRHOME}/watch
TRUID = 101
TRGID = 101

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


# Adding transmission user

echo "---------Adding transmission user----------"

sudo adduser transmission --uid ${TRUID}
sudo addgroup transmission --gid ${TRGID}


# making dirs

echo "---------making dirs----------"

sudo mkdir ${TRHOME} ${TRWATCH} ${TRDOWNLOADS} ${TRCONFIG} 


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
