useradd syn
cp conf/authorized_keys /home/syn/.ssh/authorized_keys
usermod -a -G ${TRUSR} syn

yum -y install rsync

