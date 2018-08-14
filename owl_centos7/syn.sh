useradd syn
#cp conf synid_rsa /home/syn/.ssh/id_rsa
usermod -a -G ${TRUSR} syn
