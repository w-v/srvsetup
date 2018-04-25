#!/bin/bash


wget https://raw.githubusercontent.com/w-v/srvsetup/master/dockerinstall.sh
bash dockerinstall.sh
rm dockerinstall.sh


wget https://raw.githubusercontent.com/w-v/srvsetup/master/transmission.sh
bash transmission.sh
rm transmission.sh


wget https://raw.githubusercontent.com/w-v/srvsetup/master/tinc.sh
bash tinc.sh
rm tinc.sh
