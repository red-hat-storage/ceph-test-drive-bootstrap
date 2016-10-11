# Module 3 - Ceph Object Storage interface

The Ceph object gateway, also know as the RADOS gateway, is an object storage interface built on top of the librados API to provide applications with a RESTful gateway to Ceph storage clusters. 

To access Ceph over object storage interfaces i.e. via ``swift`` or ``s3`` we need to configure Ceph Rados Gateway component. In this module we will configure ``rgw-node1``  as Ceph Rados Gateway and then test ``s3`` and ``swift`` from ``client-node1`` 

```
## Note: ##

Before proceeding with this module make sure you have completed Module-1 and have a running Ceph cluster.
```

## Installing and configuring Ceph RGW

- On ``mgmt`` node as ``ceph`` navigate to ``/usr/share/ceph-ansible/group_vars`` directory
```
$ cd /usr/share/ceph-ansible/group_vars
```
- Edit  ``all`` file 
```
$ sudo vi all
```
- Uncomment ``radosgw_dns_name`` and set it to ``rgw-node1`` 
```
radosgw_dns_name: rgw-node1
```
- Uncomment ``radosgw_frontend`` setting, save and exit file editor
```
radosgw_frontend: civetweb
```
- Create an ``rgws`` file from ``rgws.sample`` file and open it for editing
```
$ sudo cp rgws.sample rgws
$ sudo vi rgws
```
- Uncomment the ``copy_admin_key`` setting and set it to ``true`` 
```
copy_admin_key: true
```
- Add Ceph RGW host to Ansible inventory file. Edit ``/etc/ansible/hosts``  file
```
$ sudo vi /etc/ansible/hosts
```
- Add the following section to ``/etc/ansible/hosts``  file, save and exit file editor
```
[rgws]
rgw-node1
```
- Your Ansible inventory file should look like this
``` 
[mons]
mon-node1
mon-node2
mon-node3
[osds]
osd-node1
osd-node2
osd-node3
[rgws]
rgw-node1
```
- Navigate to the Ansible configuration directory ``/usr/share/ceph-ansible/``
```
$ cd /usr/share/ceph-ansible/
```
- Run the Ansible playbook
```
$ ansible-playbook site.yml -u ceph
```
```
## Note: ##

Ansible is idempotent in nature , so there is no harm in running it again. Configuration change will not take place after its initial application.
```
- Once Ansible run is completed, make sure there is no failed item under ``PLAY RECAP`` 
- Verify ``ceph-radosgw`` service is running on ``rgw-node1`` , also make a note of port number its running on. It must be 8080
```
$ ssh rgw-node1 systemctl status ceph-radosgw@rgw.rgw-node1.service
$ ssh rgw-node1 -t sudo netstat -plunt | grep -i rados
```
- Login to ``rgw-node`` to create Radow Gateway user account which will be used by ``S3`` and ``swift`` API's to access Ceph storage via object storage interface
```
$ ssh rgw-node1
```
- Create RGW user for ``S3`` access 
```
$ radosgw-admin user create --uid='user1' --display-name='First User' --access-key='S3user1' --secret-key='S3user1key'
```
- Create RGW subuser for ``swift`` access
```
$ radosgw-admin subuser create --uid='user1' --subuser='user1:swift' --secret-key='Swiftuser1key' --access=full
```
At this point you have a running and configured Ceph RGW instance. In the next section we will learn about accessing Ceph via object storage interfaces.

## Access Ceph object storage using swift API

- Login to ``client-node``
```
$ ssh client-node1
```
- Install ``python-swiftclient`` 
```
$ sudo pip install python-swiftclient
```
- Using swift cli , lets try to list swift containers. Although it will not list anything as there are no containers.
```
$ swift -A http://rgw-node1:8080/auth/1.0  -U user1:swift -K 'Swiftuser1key' list
```
- Create a swift container named ``container-1`` and then list it
```
$ swift -A http://rgw-node1:8080/auth/1.0  -U user1:swift -K 'Swiftuser1key' post container-1
$ swift -A http://rgw-node1:8080/auth/1.0  -U user1:swift -K 'Swiftuser1key' list
```
- Create a dummy file and then upload this file to ``container-1`` using swift
```
$ base64 /dev/urandom | head -c 10000000 > dummy_file1.txt
$ swift -A http://rgw-node1:8080/auth/1.0  -U user1:swift -K 'Swiftuser1key' upload container-1 dummy_file1.txt
```
- List ``container-1`` to verify files are getting stored
```
$ swift -A http://rgw-node1:8080/auth/1.0  -U user1:swift -K 'Swiftuser1key' list container-1
```

Easy right !! So you have just learned how to use Ceph as Object Storage System using swift APIs. Follow the next section to know how S3 can be used with Ceph.

## Access Ceph object storage using S3 API

Ceph object storage cluster can be accessed by any client which talks ``S3`` API.  In this section we will use ``s3cmd`` which has already been installed on ``client-node1`` machine.

- Login to ``client-node1``
```
$ ssh client-node1
```
- To use Ceph with S3-style subdomains (e.g., bucket-name.domain-name.com), you need to add a wildcard to the DNS record of the DNS server you use with the ceph-radosgw daemon. We will install ``dnsmasq`` which is a lightweight DNS server.
```
$ sudo yum install -y dnsmasq
```
- Configure dnsmasq to resolve subdomains to Ceph RGW address and start dnsmasq service
```
$ echo "address=/.rgw-node1/10.100.2.15" | sudo tee -a /etc/dnsmasq.conf
$ sudo systemctl start dnsmasq
$ sudo systemctl enable dnsmasq
```
- Edit ``/etc/resolv.conf``  and add ``nameserver 127.0.0.1`` **just after** ``search ec2.internal`` line
```
# Generated by NetworkManager
search ec2.internal
nameserver 127.0.0.1
nameserver 10.100.0.2
```
- Make sure for any RGW subdomain ``client-node1`` is resolving ``rgw-node1`` address
```
$ ping -c 1 anything.rgw-node1
$ ping -c 1 mybucket.rgw-node1
$ ping -c 1 mars.rgw-node1
```
- Next we will configure ``s3cmd`` 
```
$ s3cmd --configure
```
- ``s3cmd`` configuration will prompt to enter details, use the following  values for configuration.  Enter default values for most of the prompts , however we **do not want** to use **HTTPS** and **test configuration** right away and **we do want** to save settings.
```
Access Key: S3user1
Secret Key: S3user1key

Default Region [US]: < Just hit Enter >
Encryption password: < Just hit Enter >
Path to GPG program [/usr/bin/gpg]: < Just hit Enter >

Use HTTPS protocol [Yes]: No
HTTP Proxy server name: < Just hit Enter >

Test access with supplied credentials? [Y/n] n
Save settings? [y/N] y
```
- Sample ``s3cmd --configuration`` wizard 
```
[ceph@client-node1 ~]$ s3cmd --configure

Enter new values or accept defaults in brackets with Enter.
Refer to user manual for detailed description of all options.

Access key and Secret key are your identifiers for Amazon S3. Leave them empty for using the env variables.
Access Key: S3user1
Secret Key: S3user1key
Default Region [US]:

Encryption password is used to protect your files from reading
by unauthorized persons while in transfer to S3
Encryption password:
Path to GPG program [/usr/bin/gpg]:

When using secure HTTPS protocol all communication with Amazon S3
servers is protected from 3rd party eavesdropping. This method is
slower than plain HTTP, and can only be proxied with Python 2.7 or newer
Use HTTPS protocol [Yes]: No

On some networks all internet access must go through a HTTP proxy.
Try setting it here if you can't connect to S3 directly
HTTP Proxy server name:

New settings:
  Access Key: S3user1
  Secret Key: S3user1key
  Default Region: US
  Encryption password:
  Path to GPG program: /usr/bin/gpg
  Use HTTPS protocol: No
  HTTP Proxy server name:
  HTTP Proxy server port: 0

Test access with supplied credentials? [Y/n] n

Save settings? [y/N] y
Configuration saved to '/home/ceph/.s3cfg'
[ceph@client-node1 ~]$
```
- Next edit ``/home/ceph/.s3cfg`` file, update ``host_base`` and ``host_bucket`` as shown below. Save and exit editor
```
host_base = rgw-node1:8080
host_bucket = %(bucket)s.rgw-node1:8080
```
- Test Ceph object storage via S3 protocol by listing buckets using ``s3cmd``. It should list buckets that you have created using ``swift`` in the last section 
```
$ s3cmd ls
```
- Create a new bucket
```
$ s3cmd mb s3://s3-bucket
$ s3cmd ls
```
- Create a dummy file and then upload this file to ``s3-bucket`` via S3 API
```
$ base64 /dev/urandom | head -c 10000000 > dummy_file2.txt
$ s3cmd put dummy_file2.txt s3://s3-bucket
$ s3cmd ls s3://s3-bucket
```

> All done !! Great !!  In this module you have learned to use Ceph cluster as object storage using S3 and Swift APIs. You application will use the same procedure to storage objects to Ceph cluster.
