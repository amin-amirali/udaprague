# master provisioning

# create id_rsa and place on shared folder to be used by data nodes
# for passwordless ssh
sudo chmod +t /home
ssh-keygen -t rsa -P "" -f ~/.ssh/id_dsa
# for the slaves, use the public key
cp ~/.ssh/id_dsa.pub /shared_data/id_rsa_master.pub
cat ~/.ssh/id_dsa.pub >> ~/.ssh/authorized_keys
cat /shared_data/id_rsa_host.pub >> ~/.ssh/authorized_keys

# the ambari installation will need the private key
cp ~/.ssh/id_dsa /shared_data/id_dsa

# install base tools
yum install -y rpm curl wget unzip tar

rpm -Uvh http://repo.mysql.com/mysql-community-release-el6-5.noarch.rpm #/shared_data/mysql-community-release-el7-5.noarch.rpm
yum install -y mysql-community-server
# yum install -y mysql-server
service mysqld start
# yum install -y mysql-connector-java.noarch
yum install -y mysql-connector-java*

yum upgrade -y openssl

wget -nv http://public-repo-1.hortonworks.com/HDP/centos6/2.x/updates/2.2.4.2/hdp.repo -O /etc/yum.repos.d/hdp.repo
chmod 777 /etc/hosts
echo "192.168.2.10    master" >> /etc/hosts
echo "192.168.2.11    data1" >> /etc/hosts
echo "192.168.2.12    data2" >> /etc/hosts
echo "192.168.2.13    data3" >> /etc/hosts

yum install -y httpd
chkconfig httpd on
service httpd start
yum install -y ntp
chkconfig ntpd on
service ntpd start
chkconfig iptables off 
/etc/init.d/iptables stop
setenforce 0
echo -e "\numask 022\n" >> /etc/profile
source /etc/profile

wget -nv http://public-repo-1.hortonworks.com/ambari/centos6/2.x/updates/2.0.0/ambari.repo -O /etc/yum.repos.d/ambari.repo
yum repolist
yum install -y ambari-server
ambari-server setup -sv
sed -i 's/127.0.0.1/# 127.0.0.1/g' /etc/hosts
sed -i 's/::1/ # ::1/g' /etc/hosts
ambari-server start

