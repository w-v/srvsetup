#!/bin/bash

#ROOTDIR='/var/www/html/'
ROOTDIR=$(grep -m 1 root conf/nginx.conf | awk -F " " '{print $2}'|tr -d ';')

yum -y install nginx

cp conf/nginx.conf /etc/nginx/

ln -s ${TRDOWNLOADS} ${ROOTDIR}/dl

systemctl enable nginx.service
systemctl start nginx.service
