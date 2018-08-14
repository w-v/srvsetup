#!/bin/bash

source transmission.sh
bash tinc.sh
bash nginx.sh
bash syn.sh
cat conf/hostsfile >> /etc/hosts
