#!/bin/bash
sudo sed -i '$a\    ' /etc/ansible/hosts
sudo sed -i '$a\[rgws]' /etc/ansible/hosts
sudo sed -i '$a\ceph-admin' /etc/ansible/hosts
sudo sed -i '$a\    ' /etc/ansible/hosts

cd /usr/share/ceph-ansible
ansible-playbook site.yml --limit  rgws

sudo systemctl status ceph-radosgw@rgw.ceph-admin.service
sudo netstat -plunt | grep -i rados

sudo radosgw-admin user create --uid='user1' --display-name='First User' --access-key='S3user1' --secret-key='S3user1key'
sudo radosgw-admin subuser create --uid='user1' --subuser='user1:swift' --secret-key='Swiftuser1key' --access=full

swift -A http://ceph-admin/auth/1.0  -U user1:swift -K 'Swiftuser1key' post container-1
swift -A http://ceph-admin/auth/1.0  -U user1:swift -K 'Swiftuser1key' list

echo "address=/.ceph-admin/10.100.0.10" | sudo tee -a /etc/dnsmasq.conf
sudo systemctl start dnsmasq ; sudo systemctl enable dnsmasq

sudo sed -i '/search/anameserver 127.0.0.1' /etc/resolv.conf

ping -c 2 anything-bucket-name.ceph-admin

s3cmd --access_key=S3user1 --secret_key=S3user1key --no-ssl --host=ceph-admin --host-bucket="%(bucket)s.ceph-admin" --dump-config > /home/student/.s3cfg

s3cmd mb s3://public_bucket --acl-public
s3cmd put --acl-public  /home/student/Red_Hat_Tower.jpg s3://public_bucket
s3cmd put --acl-public /home/student/Red_Hat_Ceph_Storage.mp4 s3://public_bucket

echo "****************************************************************************************"
echo "****************************************************************************************"

echo "Public URL for the shared image: http://ceph-admin-public-IP-Address/public_bucket/Red_Hat_Tower.jpg"
echo "Public URL for the shared image: http://ceph-admin-public-IP-Address/public_bucket/Red_Hat_Ceph_Storage.mp4"
echo "For ceph-sree object storage GUI : http://ceph-admin-public-IP-Address:5000"

echo "****************************************************************************************"
echo "****************************************************************************************"
