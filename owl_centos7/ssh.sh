SSHPORT=6922

iptables -I INPUT -p tcp --dport ${SSHPORT} --syn -j ACCEPT

cp conf/sshd_config /etc/sshd/

