# Module - 2 : Setting up a Ceph cluster

RHCS 2.0 has introduced a new and more efficient way to deploy Ceph cluster. Instead of ``ceph-deploy``  RHCS 2.0 ships with ``ceph-ansible`` tool which is based on configuration management tool ``Ansible`` .

In this module we will deploy a Ceph cluster with 3 OSD nodes and 3 Monitor nodes. We will use ``ceph-ansible`` to deploy this cluster.

!!! note
    You must run all the commands using **ceph** user and from **management node**, unless otherwise specified. 

- From your workstation login to the Ceph management node as **``ceph``** user
```
$ ssh ceph@<IP address of Ceph Management node>
```  

## Installing and setting up ceph-ansible  

- Install the ceph-ansible package
```
$ sudo yum install -y ceph-ansible
```
- To keep ansible hosts file short, rename the default ansible host file
```
$ sudo mv /etc/ansible/hosts /etc/ansible/hosts-default.bkp
```
- Create a new ansible hosts file, with the following edits 
```
$ sudo vi /etc/ansible/hosts
```
- In the ``/etc/ansible/hosts`` file add Ceph monitor host names under ``[mons]``  section and Ceph OSDs host name under ``[osds]``  section . This allows ansible to know which role is to be applied

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
- Create the ``.ansible.cfg`` file and add ``host_key_checking = False`` using the commands below 
```
$ echo "[defaults]" >> /home/ceph/.ansible.cfg
$ echo "host_key_checking = False" >> /home/ceph/.ansible.cfg
```
- Ensure that Ansible can reach the Ceph hosts.
```
$ ansible all -m ping
```

## Configuring Ceph Global Settings

- Create a directory under the home directory so Ansible can write the keys
```
$ cd ~
$ mkdir ceph-ansible-keys
```
- Navigate to the Ceph Ansible ``group_vars` directory
```
$ cd /usr/share/ceph-ansible/group_vars/
```
- Create an ``all`` file from the ``all.sample``  file and open it for editing
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
- Save the file and exit from the editor

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
- Save the file and exit from editor.

## Deploying the Ceph Cluster

- Navigate to the ``ceph-ansible`` configuration directory
```
$ cd /usr/share/ceph-ansible
```
- Create a ``site.yml`` file from the ``site.yml.sample`` file 
```
$ sudo cp site.yml.sample site.yml
```
- Run the Ansible playbook
```
$ ansible-playbook site.yml -u ceph
```
- Ansible will take a few minutes to complete Ceph deployment. Once its completed, Ansible play recap should look similar to this. Make sure Ansible Play Recap does not show any host run failed.
```
PLAY RECAP ********************************************************************
mon-node1                  : ok=91   changed=19   unreachable=0    failed=0
mon-node2                  : ok=91   changed=18   unreachable=0    failed=0
mon-node3                  : ok=91   changed=18   unreachable=0    failed=0
osd-node1                  : ok=164  changed=16   unreachable=0    failed=0
osd-node2                  : ok=164  changed=16   unreachable=0    failed=0
osd-node3                  : ok=164  changed=16   unreachable=0    failed=0
```
- Finally check status of your cluster. You should have an installed and configured Ceph cluster at this point. 
```
$ ssh mon-node1 ceph -s
```
!!! note
     You can ignore any cluster health warnings at this point, We will take care of them later in this module.

> **Upto this point you should have a running Ceph cluster with 3 Ceph OSD nodes ( 9 OSDs total ) and 3 Ceph Monitor nodes.** 

## Configuring a Ceph client
By default Ceph monitor nodes are authorized to run Ceph administrative commands. For the sake of understanding how Ceph client is configured, In this section we will configure a ``mgmt`` node as our Ceph client node.

- On the ``mgmt``node install ``ceph-common`` package which provides the ``Ceph CLI`` and other tools
```
$ sudo yum install -y ceph-common
```
- Change ownership of the ``/etc/ceph`` directory
```
$ sudo chown -R ceph:ceph /etc/ceph
```
-  From ``mon-node1`` copy the Ceph configuration file (``ceph.conf``) and the Ceph administration keyring (``ceph.client.admin.keyring``) to the ``mgmt`` node
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
## Interacting with the Ceph cluster
In this section we will learn a few commands to interact with our Ceph cluster. These commands should be executed from ``mon-node1`` node.

- ssh to ``mon-node1`` 
```
$ ssh mon-node1
```
- Check cluster status
```
$ ceph -s
```
The Above cluster status command shows that the cluster health is not OK and the cluster is complaining about low PG numbers. 
Let's now try to fix this warning.

- Verify ``pg_num`` for default pool ``rbd`` 
```
$ ceph osd dump | grep -i pool
```
- Increase ``pg_num``  for ``rbd`` pool to 128 and check cluster status 
```
$ ceph osd pool set rbd pg_num 128
$ ceph -s
```
- Once the cluster is not creating new PGs , increase ``pgp_num`` for ``rbd`` pool to 128 and check cluster status. Your cluster health should now report ``HEALTH_OK``
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

> **We have reached the end of Module-2. At this point you have learned to deploy, configure and interact with your Ceph cluster.
Follow the next module to learn how to access your Ceph cluster as a Block Storage.**
