#/bin/bash

URL="https://raw.githubusercontent.com/red-hat-storage/ceph-test-drive-bootstrap/master/env-setup"

wget $URL/automated-setup/module-2.sh
wget $URL/automated-setup/module-4.sh

sudo yum install -y ceph-ansible wget
sudo mv /etc/ansible/hosts /etc/ansible/hosts-default.bkp
sudo wget -O /etc/ansible/hosts $URL/automated-setup/ansible-hosts

echo "[defaults]" >> /home/ceph/.ansible.cfg
echo "host_key_checking = False" >> /home/ceph/.ansible.cfg
ansible all -m ping

read -p "Press enter to continue"

mkdir /home/ceph/ceph-ansible-keys

sudo wget $URL/rhcs2_0/all -O /usr/share/ceph-ansible/group_vars/all
sudo wget $URL/rhcs2_0/osds -O /usr/share/ceph-ansible/group_vars/osds
sudo wget $URL/rhcs2_0/rgws -O /usr/share/ceph-ansible/group_vars/rgws

sudo cp /usr/share/ceph-ansible/site.yml.sample /usr/share/ceph-ansible/site.yml

echo "To Install RHCS Run ==> ansible-playbook /usr/share/ceph-ansible/site.yml -u ceph"
echo "For Module-2 Run ==> sh module-2.sh"
echo "For Module-4 Run ==> sh module-4.sh"
