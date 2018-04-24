#!/bin/bash

SRVNAME="menelas"
NETNAME="netnet"
SRVNETIP="10.0.0.1"
NETMASK="255.255.255.0"


# Install
apt-get update && apt-get -y upgrade && apt-get -y install tinc


# Config
mkdir /etc/tinc/${NETNAME}

echo "#Interface réseau
Device=/dev/net/tun
#Port d'écoute permettant aux autres noeuds de se connecter
Port=655
#Le VPN fonctionnera en mode switch 
#(pas besoin de définir de route mais les packets ne sont pas diffusés à tous les noeuds)
Mode=switch
#Identifiant de la machine sur le VPN
Name=${SRVNAME}
#Clé privée de la machine sur le réseau VPN
PrivateKeyFile=/etc/tinc/${NETNAME}/rsa_key.priv" > /etc/tinc/${NETNAME}/tinc.conf


# Generate keys
mkdir /etc/tinc/${NETNAME}/hosts

echo -e "Compression=9
Adress=$(hostname -I|cut -f 1 -d " ") 655" > /etc/tinc/${NETNAME}/hosts/${SRVNAME}

echo -e "\n" | sudo tincd -n ${NETNAME} -K


# Make tinc-up and down files file
echo -e "#!/bin/bash
ifconfig '$INTERFACE'" ${SRVNETIP} netmask ${NETMASK}" > /etc/tinc/${NETNAME}/tinc-up

echo -e "#!/bin/bash
ifconfig '$INTERFACE'" down" > /etc/tinc/${NETNAME}/tinc-down

sudo chmod u+rx /etc/tinc/${NETNAME}/tinc-*


# Start tink
sudo tincd -n ${NETNAME}
