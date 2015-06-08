# master provisioning

# get id_rsa from shared folder for passwordless ssh
sudo chmod +t /home
mkdir -p /root/.ssh
cat /shared_data/id_rsa_master.pub >> ~/.ssh/authorized_keys

# install base tools
yum install -y rpm curl wget unzip tar
yum upgrade -y openssl

wget -nv http://public-repo-1.hortonworks.com/HDP/centos6/2.x/updates/2.2.4.2/hdp.repo -O /etc/yum.repos.d/hdp.repo
chmod 777 /etc/hosts
sed -i 's/127.0.0.1/# 127.0.0.1/g' /etc/hosts
sed -i 's/::1/# ::1/g' /etc/hosts
echo "192.168.2.10    master" >> /etc/hosts
echo "192.168.2.11    data1" >> /etc/hosts
echo "192.168.2.12    data2" >> /etc/hosts
echo "192.168.2.13    data3" >> /etc/hosts

yum install -y ntp
chkconfig ntpd on
service ntpd start
chkconfig iptables off 
/etc/init.d/iptables stop
setenforce 0

echo -e "\numask 022\n" >> /etc/profile



