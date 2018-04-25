#!/bin/bash

HOSTDIR=/srv/tinc
SRVNAME="menelas"
NETNAME="netnet"
SRVNETIP="10.0.1.1"
SRVSUBNET="10.O.1.0/24"
NETMASK="255.255.0.0"

wget https://raw.githubusercontent.com/JensErat/docker-tinc/master/Dockerfile

mkdir -p ${HOSTDIR}/${NETNAME}

# Put address and subnet into host file
echo -e "Compression=9
Address=$(hostname -I|cut -f 1 -d " ") 655
Subnet = ${SRVSUBNET}" > ${HOSTDIR}/${NETNAME}/hosts/${SRVNAME}

# Run tinc init to generate keys
docker run --name tincinit --volume ${HOSTDIR}:/etc/tinc --rm jenserat/tinc -n ${NETNAME} init ${SRVNAME}

# Make conf file
echo "Name=${SRVNAME}
AddressFamily = ipv4
Interface = tun0" > ${HOSTDIR}/${NETNAME}/tinc.conf

# Make tinc-up and down files 
echo -e "#!/bin/bash
ifconfig "'$INTERFACE'" ${SRVNETIP} netmask ${NETMASK}" > ${HOSTDIR}/${NETNAME}/tinc-up

echo -e "#!/bin/bash
ifconfig "'$INTERFACE'" down" > ${HOSTDIR}/${NETNAME}/tinc-down

sudo chmod u+rx ${HOSTDIR}/${NETNAME}/tinc-*

docker run -d \
    --name tinc \
    --net=host \
    --device=/dev/net/tun \
    --cap-add NET_ADMIN \
    --volume ${HOSTDIR}:/etc/tinc \
    jenserat/tinc start -D -n ${NETNAME}
