#!/bin/bash
mkdir ~/ceph-ansible-keys

sudo touch /etc/ansible/hosts
sudo ex -sc '1i|   ' -cx /etc/ansible/hosts

sudo sed -i '$a\[mons]' /etc/ansible/hosts
sudo sed -i '$a\ceph-node[1:3]' /etc/ansible/hosts
sudo sed -i '$a\    ' /etc/ansible/hosts

sudo sed -i '$a\[osds]' /etc/ansible/hosts
sudo sed -i '$a\ceph-node[1:4]' /etc/ansible/hosts
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
