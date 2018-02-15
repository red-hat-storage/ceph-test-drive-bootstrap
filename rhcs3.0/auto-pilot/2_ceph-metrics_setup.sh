#!/bin/bash

sudo sed -i '$a\[ceph-grafana]' /etc/ansible/hosts
sudo sed -i '$a\ceph-admin ansible_connection=local' /etc/ansible/hosts
sudo sed -i '$a\    ' /etc/ansible/hosts

cd /usr/share/cephmetrics-ansible
time ansible-playbook playbook.yml
sudo chown -R student:student /etc/ceph

echo "****************************************************************************************"
echo "Ceph-Metrics Dashboard : http://ceph-admin-node-public-IP:3000"
echo "****************************************************************************************"
