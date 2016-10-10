# Module 2 - Ceph Block Storage interface

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
> This is it, we are done. Application can now consume block device coming from Ceph.
