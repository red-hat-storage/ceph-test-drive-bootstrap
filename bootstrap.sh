exec >> /var/tmp/instance-bootstrap.log 2>&1
set -x

yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum install -y ansible vim wget
yum remove -y epel-release
#useradd ceph
#echo "ceph:RedHat16" | chpasswd
