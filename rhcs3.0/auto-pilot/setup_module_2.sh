#!/bin/bash
mkdir ~/ceph-ansible-keys

sudo touch /etc/ansible/hosts
sudo ex -sc '1i|   ' -cx /etc/ansible/hosts

sudo sed -i '$a\[mons]' /etc/ansible/hosts
sudo sed -i '$a\ceph-node[1:3]' /etc/ansible/hosts
sudo sed -i '$a\    ' /etc/ansible/hosts

sudo sed -i '$a\[osds]' /etc/ansible/hosts
sudo sed -i '$a\ceph-node[1:3]' /etc/ansible/hosts
sudo sed -i '$a\    ' /etc/ansible/hosts

sudo sed -i '$a\[mgrs]' /etc/ansible/hosts
sudo sed -i '$a\ceph-admin' /etc/ansible/hosts
sudo sed -i '$a\    ' /etc/ansible/hosts

sudo sed -i '$a\[clients]' /etc/ansible/hosts
sudo sed -i '$a\ceph-admin' /etc/ansible/hosts
sudo sed -i '$a\    ' /etc/ansible/hosts

cd /usr/share/ceph-ansible
time ansible-playbook site.yml

sudo chown -R student:student /etc/ceph
ceph osd erasure-code-profile set my_ec_profile k=2 m=1 ruleset-failure-domain=host
ceph osd pool create ecpool 128 128 erasure my_ec_profile
ceph osd pool application enable ecpool benchmarking

sudo sed -i '$a\[ceph-grafana]' /etc/ansible/hosts
sudo sed -i '$a\ceph-admin ansible_connection=local' /etc/ansible/hosts
sudo sed -i '$a\    ' /etc/ansible/hosts

cd /usr/share/cephmetrics-ansible
time ansible-playbook playbook.yml
sudo chown -R student:student /etc/ceph

echo "****************************************************************************************"
echo "Ceph-Metrics Dashboard : http://insert-ceph-admin-node-public-IP:3000"
echo "Ceph-Metrics Username  : admin"
echo "Ceph-Metrics Password  : admin"
echo "****************************************************************************************"
