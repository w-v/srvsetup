#!/bin/bash

TRHOME=/home/transmission
TRCONFIG=${TRHOME}/config
TRDOWNLOADS=${TRHOME}/downloads
TRWATCH=${TRHOME}/watch
TRUID=1001
TRGID=1001


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

docker container start transmission

