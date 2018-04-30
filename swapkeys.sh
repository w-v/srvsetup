#!/bin/bash

SRVNAME="menelas"
HOMENAME="paris"
NETNAME="netnet"
HOMENETIP="10.0.0.2"
NETMASK="255.255.255.0"
HOMENETPATH="/etc/tinc/${NETNAME}"
SRVNETPATH="/srv/tinc/${NETNAME}"

# Giving home key to server
scp ${HOMENETPATH}/hosts/${HOMENAME} root@${1}:${SRVNETPATH}/hosts

# Giving server key to home
scp root@${1}:${SRVNETPATH}/hosts/${SRVNAME} ${HOMENETPATH}/hosts/${SRVNAME}
