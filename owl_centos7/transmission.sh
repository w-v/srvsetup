#!/bin/bash

export TRUSR='tr'
TRGROUP='tr'
export TRHOME=/home/${TRUSR}
TRCONFIG=${TRHOME}/config
export TRDOWNLOADS=${TRHOME}/dl
TRINCOMPLETE=${TRHOME}/part
TRWATCH=${TRHOME}/watch

# requirements

echo "---------Installing requirements----------"

yum -y install epel-release
yum -y update
yum -y install transmission-cli transmission-common transmission-daemon


# Adding transmission user

echo "---------Adding transmission user----------"

usermod -l ${TRUSR} transmission
groupmod -n ${TRGROUP} transmission

# making dirs

echo "---------Making dirs----------"

mkdir ${TRHOME} ${TRWATCH} ${TRINCOMPLETE} ${TRDOWNLOADS} ${TRCONFIG} 
chown ${TRUSR}:${TRGROUP} ${TRHOME} ${TRINCOMPLETE} ${TRWATCH} ${TRDOWNLOADS} ${TRCONFIG} 

# configuring transmission-daemon

echo "---------Configuring transmission-daemon----------"

transmission-daemon -g ${TRCONFIG} &
sleep 2
transmission-remote --exit
cp settings.json ${TRCONFIG} && echo "---------Installed user settings----------"

systemctl enable transmission-daemon.service
