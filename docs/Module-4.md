# Module 4 - Scaling up a Ceph cluster

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
> At this point we have scaled up our Ceph cluster to 4 OSD node, without any downtime or service breaks. This shows, how seamless is Ceph scale up operation