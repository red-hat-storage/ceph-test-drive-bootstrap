#/bin/bash

sudo yum install -y ceph-ansible
sudo mv /etc/ansible/hosts /etc/ansible/hosts-default.bkp
sudo cp ansible-hosts /etc/ansible/hosts
echo "[defaults]" >> /home/ceph/.ansible.cfg
echo "host_key_checking = False" >> /home/ceph/.ansible.cfg
ansible all -m ping

mkdir /home/ceph/ceph-ansible-keys

sudo wget all -O /usr/share/ceph-ansible/group_vars/all
sudo wget osds -O /usr/share/ceph-ansible/group_vars/osds
sudo wget rgws -O /usr/share/ceph-ansible/group_vars/rgws

sudo cp /usr/share/ceph-ansible/site.yml.sample /usr/share/ceph-ansible/site.yml
ansible-playbook /usr/share/ceph-ansible/site.yml -u ceph


sudo yum install -y ceph-common;
sudo chown -R ceph:ceph /etc/ceph;
scp mon-node1:/etc/ceph/ceph.client.admin.keyring mgmt:/etc/ceph/ceph.client.admin.keyring;
scp mon-node1:/etc/ceph/ceph.conf mgmt:/etc/ceph/ceph.conf;
chmod 400 /etc/ceph/ceph.client.admin.keyring;
sudo chown -R ceph:ceph /etc/ceph;


ssh rgw-node1 -t  radosgw-admin user create --uid='user1' --display-name='First User' --access-key='S3user1' --secret-key='S3user1key'
ssh rgw-node1 -t radosgw-admin subuser create --uid='user1' --subuser='user1:swift' --secret-key='Swiftuser1key' --access=full

