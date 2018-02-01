#!/bin/bash
mkdir ~/ceph-ansible-keys
cd /usr/share/ceph-ansible

sudo sed -i '$a\[mons]' /etc/ansible/hosts
sudo sed -i '$a\ceph-node[1:3]' /etc/ansible/hosts
sudo sed -i '$a\    ' /etc/ansible/hosts

sudo sed -i '$a\[osds]' /etc/ansible/hosts
sudo sed -i '$a\ceph-node[1:4]' /etc/ansible/hsots
sudo sed -i '$a\    ' /etc/ansible/hosts

sudo sed -i '$a\[clients]' /etc/ansible/hosts
sudo sed -i '$a\ceph-admin' /etc/ansible/hosts
sudo sed -i '$a\    ' /etc/ansible/hosts

time ansible-playbook site.yml

