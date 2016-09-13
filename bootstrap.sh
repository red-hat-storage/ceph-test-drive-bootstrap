#!/bin/bash
yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum install -y ansible vim
yum remove -y epel-release
useradd ceph
echo "ceph:RedHat16" | chpasswd
