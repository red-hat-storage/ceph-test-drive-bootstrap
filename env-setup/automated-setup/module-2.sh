#/bin/bash

sudo yum install -y ceph-common;
sudo chown -R ceph:ceph /etc/ceph;
scp mon-node1:/etc/ceph/ceph.client.admin.keyring mgmt:/etc/ceph/ceph.client.admin.keyring;
scp mon-node1:/etc/ceph/ceph.conf mgmt:/etc/ceph/ceph.conf;
chmod 400 /etc/ceph/ceph.client.admin.keyring;
sudo chown -R ceph:ceph /etc/ceph;

