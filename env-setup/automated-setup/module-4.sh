#/bin/bash
echo "==============================="
echo "Creating RGW user for S3 access"
echo "==============================="
ssh rgw-node1 -t  radosgw-admin user create --uid='user1' --display-name='First User' --access-key='S3user1' --secret-key='S3user1key'

echo "======================================"
echo "Creating RGW subuser for swift access"
echo "======================================"
ssh rgw-node1 -t radosgw-admin subuser create --uid='user1' --subuser='user1:swift' --secret-key='Swiftuser1key' --access=full
