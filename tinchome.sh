#!/bin/bash

SRVNAME="menelas"
HOMENAME="paris"
NETNAME="netnet"
HOMENETIP="10.0.0.2"
NETMASK="255.255.255.0"
NETPATH="/etc/tinc/${NETNAME}"

sudo mkdir -p ${NETPATH}/hosts

echo "Name = ${HOMENAME}
AddressFamily = ipv4
Interface = tun0
ConnectTo = ${SRVNAME}" > ${NETPATH}/tinc.conf

echo "Subnet=${HOMENETIP}" > ${NETPATH}/hosts/${HOMENAME}

echo -e "\n" | sudo tincd -n ${NETNAME} -K4096

sudo echo "ifconfig "'$INTERFACE'" ${HOMENETIP} netmask 255.255.255.0" > ${NETPATH}/tinc-up

sudo echo "ifconfig "'$INTERFACE'" down" > ${NETPATH}/tinc-down 

sudo chmod 755 ${NETPATH}/tinc-*

# Giving home key to server
scp ${NETPATH}/hosts/${HOMENAME} root@${1}:${NETPATH}/hosts

# Giving server key to home
scp root@${1}:${NETPATH}/hosts/${SRVNAME} ${NETPATH}/hosts/${SRVNAME}
