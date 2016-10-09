# Red Hat Ceph Storage Test Drive

## Introduction

Welcome to Red Hat Ceph Storage Hands-on Lab. To make your Ceph experience awesome , the contents of this test drive have been divided into following modules.

- **Module 1 :** Setting up a Ceph cluster
- **Module 2 :** Accessing Ceph cluster via Block Storage interface
- **Module 3 :** Accessing Ceph cluster via Object Storage interface
- **Module 4 :** Scaling up a Ceph cluster

## Prerequisites
- **For Windows user :** you will need a Secure Shell client like PuTTY to connect to your instance. If you do not have it already, you can download the PuTTY client here: http://the.earth.li/~sgtatham/putty/latest/x86/putty.exe
- **For Mac and Linux users:**  you will use a Terminal application to SSH into LAB machine (this should already be installed on your host). 

## Getting to know your Lab Environment

### Starting LAB
- To launch your LAB Environment, click  ![](http://us-west-2-aws-training.s3.amazonaws.com/awsu-spl/spl02-working-ebs/media/image005.png) button from the Lab panel. Hang tight , it will take a few minutes to launch LAB resources.
- Once LAB is launched, **Connect** tab will appear on Right side of the screen. Use the **Management Node IP** to connect to LAB instances.

  **NOTE** If the **Connect** tab is unavailable, make sure you click **Start Lab** at the top of your screen.

- On the **Lab Details** tab, notice the lab properties:
    - **Setup Time -** The estimated time for the lab to start your instance so you can access the lab environment.
    - **Duration -** The estimated time the lab should take to complete.
    - **Access -** The time lab will run before automatically shutting down.

### Accessing LAB
- Open SSH client software on our workstation.
- As **``ceph``** user, SSH into Ceph Management node by using **Management node IP address** which you can get from **connect** tab.
- SSH into the node using the following command and provided credentials
  - ``$ ssh ceph@<Mangement Node IP Address>``
  - Login Credentials  ⇒ **User Name:** ``ceph`` and **Password:** ``Redhat16``

**Note:**
- Make sure you are logging in as **``ceph``** user 
- Make sure you are logging in as **your LAB environment** Management node IP address
- Type **``yes``** when ssh prompts for confirmation before establishing connection 

**Example Snippet:** 
```
$ ssh ceph@52.55.48.166
The authenticity of host '52.55.48.166 (52.55.48.166)' can't be established.
ECDSA key fingerprint is 23:36:98:4f:18:cc:60:98:35:34:58:8e:85:46:67:66.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '52.55.48.166' (ECDSA) to the list of known hosts.
ceph@52.55.48.166's password:
Last login: Fri Oct  7 05:47:16 2016 from a91-156-42-216.elisa-laajakaista.fi
[ceph@mgmt ~]$
```

### Terminating LAB

Follow these steps to end your lab environment and share your experience.

- Close your remote session.
- In the *qwik*LABS page, click **End Lab**.
- In the confirmation message, click **OK**.
- Tell us about your lab experience on Ceph and suggestions to improve this environment



# Getting to know Red Hat Ceph Storage

## Introduction

Red Hat Ceph Storage is a scalable, open, software-defined storage platform that combines the most stable version of the Ceph storage system with a Ceph management platform, deployment utilities, and support services. 

Red Hat Ceph Storage is designed for cloud infrastructure and web-scale object storage. Red Hat Ceph Storage clusters consist of the following types of nodes:

- Red Hat Storage Management node
- Monitor nodes
- OSD nodes
- Object Gateway nodes
- MDS nodes

## Prerequisites
Setting up a Ceph cluster requires the following configuration on the cluster nodes.

- **Operating System :**  Heterogeneous and supported version of OS.
- **Registration to CDN :** To get necessary packages required for installation either from RHN (Red Hat Network) or other trusted sources.
- **Enabling Ceph Repositories :** To get Ceph packages from CDN or from Local repositories.
- **Separate networks :** For Public and Cluster traffic.
- **Setting hostname resolutions :** Either local or DNS name resolution 
- **Configuring firewall :**  Allow necessary port to be opened.
- **NTP configuration:** For time synchronization across nodes.
- **Local user account:** User with passwordless sudo ssh access to all nodes, for Ceph deployment using Ansible.

```
## Note: ##

The purpose of Red Hat Ceph Storage Test Drive is to provide you an environment where you can focus on learning this great technology, without spending any time in fulfilling prerequisites. All the prerequisites listed above has been taken care for rest of this course.
```
So without further delays, please go ahead and follow these modules to gain experience on Ceph.

# Module 1 : Setting up a Ceph cluster

RHCS 2.0 has introduced a new and more efficient way to deploy Ceph cluster. Instead of ``ceph-deploy``  RHCS 2.0 ships with ``ceph-ansible`` tool which is based on configuration management tool ``Ansible`` .

In this module we will deploy a Ceph cluster with 3 OSD nodes and 3 Monitor nodes. As mentioned above we will use ``ceph-ansible`` to do this.

```
## Note: ##

You must run all the commands using ceph user and from management node, Unless otherwise specified. 
```
- From your workstation login to Ceph management node as **``ceph``** user
```
$ ssh ceph@<IP address of Ceph Management node>
```

## Installing and setting up ceph-ansible

- Install ceph-ansible package
```
$ sudo yum install -y ceph-ansible
```
- Rename default ansible host file, its of no much use.
```
$ sudo mv /etc/ansible/hosts /etc/ansible/hosts-default.bkp
```
- Create a new ansible hosts file, with the following content.
```
$ sudo vi /etc/ansible/hosts
```
- Under ``/etc/ansible/hosts`` file add Ceph monitor host names under ``[mons]``  section and Ceph OSDs host name under ``[osds]``  section . This allows ansible to know which role to be applied on which host.

```
[mons]
mon-node1
mon-node2
mon-node3
[osds]
osd-node1
osd-node2
osd-node3
```
- Ensure that Ansible can reach to Ceph hosts.
```
$ ansible all -m ping
```

## Configuring Ceph Global Settings

- Create a directory under the home directory so Ansible can write the keys
```
$ cd ~
$ mkdir ceph-ansible-keys
```
- Navigate to the Ceph Ansible group_vars directory
```
$ cd /usr/share/ceph-ansible/group_vars/
```
- Create an ``all``  file from the ``all.sample``  file and open it for editing
```
$ sudo cp all.sample all
$ sudo vi all
```
- Uncomment ``fetch_directory`` setting under the ``GENERAL`` section and point it to directory we created previously for ceph-ansible-keys
```
fetch_directory: ~/ceph-ansible-keys
```
- Under ``Stable Releases`` section and ``ENTERPRISE VERSION RED HAT STORAGE`` subsection, uncomment ``ceph_stable_rh_storage`` setting and set it to **``true``**
```
ceph_stable_rh_storage: true
```
- Uncomment the ``ceph_stable_rh_storage_iso_install`` setting and set it to **``true``** 
```
ceph_stable_rh_storage_iso_install: true
```
- Uncomment the ``ceph_stable_rh_storage_iso_path`` setting and specify the path to RHCS 2.0 ISO image
```
ceph_stable_rh_storage_iso_path: /home/ceph/rhceph-2.0-rhel-7-x86_64.iso
```
- Uncomment the ``cephx`` setting under ``CEPH CONFIGURATION`` section
```
cephx: true
```
- Uncomment the ``monitor_interface`` setting under ``Monitor options`` section and specify monitor node interface name.
```
monitor_interface: eth0
```
- Set the ``journal_size``  setting
```
journal_size: 4096
```
- Set the ``public_network`` and ``cluster_network`` settings
```
public_network: 10.100.2.0/24
cluster_network: 10.100.1.0/24
```
- Save the file and exit from editor

## Configuring Ceph OSD Settings
- To disk devices as Ceph OSD, verify disks logical names. In most cases disk name should be ``xvdb`` ``xvdc`` and ``xvdd`` 
```
$ ssh osd-node1 lsblk
```
- To define Ceph OSDs , navigate to the ``/usr/share/ceph-ansible/group_vars/``  directory
```
$ cd /usr/share/ceph-ansible/group_vars/
```
- Create an ``osds`` file from ``osds.sample`` file and open it for editing
```
$ sudo cp osds.sample osds
$ sudo vi osds
```
- Uncomment the ``crush_location`` setting and the ``osd_crush_location`` setting
```
crush_location: false
osd_crush_location: "'root={{ ceph_crush_root }} rack={{ ceph_crush_rack }} host={{ ansible_hostname }}'"
```

- To add OSD devices, uncomment the ``devices:`` section and add the OSD devices logical name ``/dev/xvdb`` and ``/dev/xvdc`` and ``/dev/xvdd`` to the list of devices
```
devices:
  - /dev/xvdb
  - /dev/xvdc
  - /dev/xvdd
```
- Uncomment the ``journal_collocation`` setting and specify **``true``** so that OSDs can use co-located journals
```
journal_collocation: true
```

## Deploying Ceph Cluster

- Navigate to the ``ceph-ansible`` configuration directory
```
$ cd /usr/share/ceph-ansible
```
- Create a ``site.yml`` file from the ``site.yml.sample`` file 
```
$ sudo cp site.yml.sample site.yml
```
- (optional) Add ``host_key_checking = False`` in ``ansible.cfg`` 
```
$ sudo vi ansible.cfg
```
- Run the Ansible playbook
```
$ ansible-playbook site.yml -u ceph
```
- Ansible will take a few minutes to complete Ceph deployment. Once its completed Ansible play recap should look similar to this. Make sure Ansible Play Recap does not show any host run failed.
```
PLAY RECAP ********************************************************************
mon-node1                  : ok=91   changed=19   unreachable=0    failed=0
mon-node2                  : ok=91   changed=18   unreachable=0    failed=0
mon-node3                  : ok=91   changed=18   unreachable=0    failed=0
osd-node1                  : ok=164  changed=16   unreachable=0    failed=0
osd-node2                  : ok=164  changed=16   unreachable=0    failed=0
osd-node3                  : ok=164  changed=16   unreachable=0    failed=0
```
- Finally check status of your cluster. 
```
$ ssh mon-node1 ceph -s
```
```
## Note: ##

At this point ignore any cluster health warnings. We will take care of them in later modules.
```

Upto this point you should have a running Ceph cluster with 3 OSD node ( 9 OSDs total ) and 3 Monitors. Follow 

## Configuring Ceph client
By default Ceph monitor nodes are authorized to run Ceph administrative commands. For the sake of understanding how Ceph client is configured, In this section we will configure ``mgmt`` node as our Ceph client node.

- On ``mgmt``node install ``ceph-common`` package which provides ``Ceph CLI``  and other tools
```
$ sudo yum install -y ceph-common
```
- Change ownership of ``/etc/ceph`` directory
```
$ sudo chown -R ceph:ceph /etc/ceph
```
-  From ``mon-node1`` copy Ceph configuration file (``ceph.conf``) and Ceph administration keyring (``ceph.client.admin.keyring``) to ``mgmt`` node
```
$ ssh mon-node1 -t cat /etc/ceph/ceph.conf | tee /etc/ceph/ceph.conf
```
```
$ ssh mon-node1 -t cat /etc/ceph/ceph.client.admin.keyring | tee /etc/ceph/ceph.client.admin.keyring
```
```
$ chmod 400 /etc/ceph/ceph.client.admin.keyring
$ sudo chown -R ceph:ceph /etc/ceph
```
- Verify ``mgmt`` node which is our Ceph client , can run Ceph commands
```
[ceph@mgmt ~]$ ceph -s
    cluster 32ab020c-e510-4884-ab0a-63944c2c6b35
     health HEALTH_WARN
            too few PGs per OSD (21 < min 30)
     monmap e1: 3 mons at {mon-node1=10.100.2.11:6789/0,mon-node2=10.100.2.12:6789/0,mon-node3=10.100.2.13:6789/0}
            election epoch 6, quorum 0,1,2 mon-node1,mon-node2,mon-node3
     osdmap e20: 9 osds: 9 up, 9 in
            flags sortbitwise
      pgmap v33: 64 pgs, 1 pools, 0 bytes data, 0 objects
            300 MB used, 863 GB / 863 GB avail
                  64 active+clean
[ceph@mgmt ~]$
```
## Interacting with Ceph cluster
In this section we will learn a few commands to interact with Ceph cluster. These commands should be executed from ``mon-node1`` node.

- ssh to ``mon-node1`` 
```
$ ssh mon-node1
```
- Check cluster status
```
$ ceph -s
```
- Above cluster status command shows that cluster health is not OK and cluster is complaining about low PG numbers. Lets now try to fix this warning.
	- Verify ``pg_num`` for default pool ``rbd`` 
	```
	$ ceph osd dump | grep -i pool
	```
	- Increase ``pg_num``  for ``rbd`` pool to 128 and check cluster status 
	```
	$ ceph osd pool set rbd pg_num 128
	$ ceph -s
    ```
  - Once cluster is not creating new PGs , increase ``pgp_num`` for ``rbd`` pool to 128 and check cluster status. Your cluster health should now report ``HEALTH_OK``
  ```
  $ ceph osd pool set rbd pgp_num 128
  $ ceph -s
  ```


- Check Ceph OSD stats and tree view of OSDs in cluster
```
$ ceph osd stat
$ ceph osd tree
```
- Check Ceph monitor status
```
$ ceph mon stat
```

- List and check Ceph pool status
```
$ ceph osd lspools
$ ceph df
$ ceph osd dump | grep -i pool
```

# Module 2 : Accessing Ceph cluster via Block Storage interface

In this module we will learn how to provision block storage using Ceph. We will create thin-provisioned, resizable RADOS Block Device (RBD) volume, which will be mapped to ``client-node1`` and will be taken into use.

```
## Note: ##

Before proceeding with this module make sure you have completed Module-1 and have a running Ceph cluster
```

- From ``mgmt`` node  configure ``client-node1``  as Ceph client by installing ``ceph-common`` package and changing ownership of ``/etc/ceph`` directory. 
```
$ ssh client-node1 -t sudo yum install -y ceph-common
$ ssh client-node1 -t sudo chown -R ceph:ceph /etc/ceph
```
- From ``mgmt`` node create a block device user named ``client.rbd`` with necessary permissions on Ceph Monitor and OSDs
```
$ ceph auth get-or-create client.rbd mon 'allow r' osd 'allow rwx pool=rbd' -o /etc/ceph/ceph.client.rbd.keyring
```
- From ``mgmt`` node copy ``ceph.conf`` and ``rbd.keyring`` file to ``client-node1`` 
```
$ scp /etc/ceph/ceph.conf client-node1:/etc/ceph
$ scp /etc/ceph/ceph.client.rbd.keyring client-node1:/etc/ceph
```
- From ``client-node1`` verify Ceph cluster is accessible by ``rbd`` user
```
$ ssh client-node1
$ ceph -s --id rbd
``` 
-  From ``client-node1`` create RBD block device with name ``block-disk1`` of size ``10G``
```
$ rbd create block-disk1 --size 10240 --image-feature layering --id rbd
```
- Verify block device that we have just created
```
$ rbd ls --id rbd
$ rbd info block-disk1 --id rbd
```
- Load and verify RBD kernel module
```
$ sudo modprobe rbd
$ lsmod | grep -i rbd
```
- Map ``block-disk1`` on ``client-node1`` 
```
$ sudo rbd map block-disk1 --id rbd
```
- Verify mapped RBD block device
```
$ rbd showmapped --id rbd
```
- Make a note of mapped device name , in most of the cases it should be ``/dev/rbd0`` and create ``xfs`` filesystem on it 
```
$ sudo mkfs.xfs /dev/rbd0
$ sudo mount /dev/rbd0 /mnt
$ df -h /mnt
```
- Lets run a quick ``dd`` write test on this block device. Meanwhile this test is going on, you can watch cluster status from a separate ssh connection to ``mgmt``node using `` watch ceph -s`` command
```
$ sudo dd if=/dev/zero of=/mnt/file1 bs=4M oflag=direct count=500
```
This is it, we are done. Application can now consume block device coming from Ceph.

# Module 3 : Accessing Ceph cluster via Object Storage interface
The Ceph object gateway, also know as the RADOS gateway, is an object storage interface built on top of the librados API to provide applications with a RESTful gateway to Ceph storage clusters. To access Ceph over object storage interfaces i.e. via ``swift`` or ``s3`` we need to configure Ceph Rados Gateway component. In this module we will configure ``rgw-node1``  as Ceph Rados Gateway and then test ``s3`` and ``swift`` from ``client-node1`` 

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
- Add Ceph RGW host to Ansible inventory file 
	- Edit ``/etc/ansible/hosts``  file
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
$ swift -A http://rgw-node1:8080/auth/1.0  -U user1:swift -K 'Swiftuser1key' list
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

All done !! Great !!  In this module you have learned to use Ceph cluster as object storage using S3 and Swift APIs. You application will use the same procedure to storage objects to Ceph cluster.

# Module 4 : Scaling up a Ceph cluster

```
## Note: ##

Before proceeding with this module make sure you have completed Module-1 and have a running Ceph cluster.
```

Ceph is designed to scale to exabyte level. Scaling a Ceph cluster is a matter of just adding nodes and Ceph will take care of the rest. In this module we will add a new OSD node ``osd-node4`` with 3 drives to our existing Ceph cluster of 3 OSD nodes. 

- We currently have 3 OSD Ceph cluster with total 9 OSDs, lets verify it again
```
$ ceph osd stat
$ ceph osd tree
```
Once new node ``osd-node4`` is added we will then have 4 Node Ceph cluster with 12 disks altogether.

- To scale up Ceph cluster, login to ``mgmt`` node which is our ceph-ansible node

- Edit ``/etc/ansible/hosts`` file
```
$ sudo vi /etc/ansible/hosts
```
- Add ``osd-node4`` under ``[osds]`` section. Save and exit editor
```
[mons]
mon-node1
mon-node2
mon-node3
[osds]
osd-node1
osd-node2
osd-node3
osd-node4
[rgws]
rgw-node1
```
- Navigate to the Ansible configuration directory ``/usr/share/ceph-ansible/``
```
$ cd /usr/share/ceph-ansible/
```
- Now run Ansible playbook, which will make sure ``osd-node4`` is added to existing Ceph cluster
```
$ ansible-playbook site.yml -u ceph
```
- Once Ansible run is completed, make sure there is no failed item under ``PLAY RECAP`` 
- So ceph-ansible has scaled up our Ceph cluster, lets verify it
```
$ ceph osd stat
$ ceph osd tree
$ ceph -s
```
At this point we have scaled up our Ceph cluster to 4 OSD node, without any downtime or service breaks.
This shows, how seamless is Ceph scale up operation

