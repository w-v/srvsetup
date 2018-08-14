#!/bin/bash

SRVNAME="menelas"
NETNAME="netnet"
SRVNETIP="10.0.1.1"
NETMASK="255.255.0.0"


# Install

#yum -y install epel-release
#yum -y update 
yum -y install tinc
yum -y install net-tools


# Config
mkdir -p /etc/tinc/${NETNAME}

echo "Name=${SRVNAME}
AddressFamily = ipv4
Interface = tun0" > /etc/tinc/${NETNAME}/tinc.conf

#---------BETTER COPY AN EXISTING ONE----------#
# Generate keys
#mkdir /etc/tinc/${NETNAME}/hosts
#echo -e "\n" | sudo tincd -n ${NETNAME} -K4096
#----------------------------------------------#

# Copying keys

cp -r conf/hosts /etc/tinc/${NETNAME}
cp conf/rsa_key.priv /etc/tinc/${NETNAME}

# Eventually replace the address automatically
#echo -e "Compression=9
#Address=$(hostname -I|cut -f 1 -d " ") 655" > /etc/tinc/${NETNAME}/hosts/${SRVNAME}



# Make tinc-up and down files file
echo -e "#!/bin/bash
ifconfig "'$INTERFACE'" ${SRVNETIP} netmask ${NETMASK}" > /etc/tinc/${NETNAME}/tinc-up

echo -e "#!/bin/bash
ifconfig "'$INTERFACE'" down" > /etc/tinc/${NETNAME}/tinc-down

chmod u+rx /etc/tinc/${NETNAME}/tinc-*


# Start tink
tincd -n ${NETNAME}
