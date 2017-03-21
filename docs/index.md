!!! note
    - If you encounter any bugs or documentation errors, please send an email to  **karan@redhat.com**

## Introduction

Welcome to Red Hat Ceph Storage Hands-on Lab. To make your Ceph experience awesome , the contents of this test drive have been divided into following modules.

- [**Module 1 :** Introduction Ceph Storage](https://red-hat-storage.github.io/ceph-test-drive-bootstrap/Module-1/)
- [**Module 2 :** Setting up a Ceph cluster](https://red-hat-storage.github.io/ceph-test-drive-bootstrap/Module-2/) (Compulsory Module)
- [**Module 3 :** Accessing Ceph cluster via Block Storage interface](https://red-hat-storage.github.io/ceph-test-drive-bootstrap/Module-3/)
- [**Module 4 :** Accessing Ceph cluster via Object Storage interface](https://red-hat-storage.github.io/ceph-test-drive-bootstrap/Module-4/)
- [**Module 5 :** Scaling up a Ceph cluster](https://red-hat-storage.github.io/ceph-test-drive-bootstrap/Module-5/)
- [**Module 6 :** MySQL Database on Ceph](https://red-hat-storage.github.io/ceph-test-drive-bootstrap/Module-6/) (Comming Soon)

## What is Red Hat Ceph Storage

Red Hat Ceph Storage ( RHCS ) is a scalable, open source, software-defined storage platform that combines the most stable version of the Ceph storage system with a Ceph management platform, deployment utilities, and support services. 

Red Hat Ceph Storage is designed for cloud infrastructure and web-scale object storage. Red Hat Ceph Storage clusters consist of the following types of nodes:

- Red Hat Storage Management node
- Monitor nodes
- OSD nodes
- Object Gateway nodes
- MDS nodes

## About the Test Drive


The Red Hat Ceph Storage Hands-on Test Drive is designed in a progressive modular format. Newcomers to Ceph will generally have the best experience by following the modules and steps in order. The modules are designed to be independent and not reliant on the activities of any preceeding module except Module-2 (Setting up a Ceph cluster) which is compulsory and required for later modules.

While the guided lab processes is designed to offer a progressive educational experience, you are also encouraged to use the lab in a free-form manner to explore Ceph and its features. For your convenience, a reference of the lab resources is provided below.

### LAB Resources

|   Lab Node   | Internal IP Address |          Function         |
|:------------:|:-------------------:|:-------------------------:|
|     mgmt     |     10.100.0.72     |    Ceph Management Node   |
|   osd-node1  |     10.100.1.11     |      Ceph OSD Node-1      |
|   osd-node2  |     10.100.1.12     |      Ceph OSD Node-2      |
|   osd-node3  |     10.100.1.13     |      Ceph OSD Node-3      |
|   osd-node4  |     10.100.1.14     |      Ceph OSD Node-4      |
|   mon-node1  |     10.100.2.11     |    Ceph Monitor Node-1    |
|   mon-node2  |     10.100.2.12     |    Ceph Monitor Node-2    |
|   mon-node3  |     10.100.2.13     |    Ceph Monitor Node-3    |
| client-node1 |     10.100.2.14     |     Ceph Client Node-1    |
|   RGW-node1  |     10.100.2.15     | Ceph Rados Gateway Node-1 |

## Test Drive Prerequisites

### SSH and RDP

- **For Windows users :** you will need a Secure Shell client like PuTTY to connect to your instance. If you do not have it already, you can download the PuTTY client [here](http://the.earth.li/~sgtatham/putty/latest/x86/putty.exe)
- **For Mac and Linux users:**  you will need a Terminal application to SSH into LAB machine (this should already be installed on your host). 

## Know your Lab Environment


!!! note
    **Module 1** is not hands-on and does not require the lab to be started. Because the time limit will begin after clicking the **Start Lab** button, you may wish to wait until you are ready to begin a later module before you click the button. 

### Starting the LAB

- On the **Lab Details** tab, notice the lab properties:
    - **Setup Time -** The estimated time for the lab to start your instance so you can access the lab environment.
    - **Duration -** The estimated time the lab should take to complete.
    - **Access -** The time lab will run before automatically shutting down.

- To launch your LAB Environment, click **Start Lab** button from the Lab panel. Hang tight , it will take **12-15 minutes** to launch LAB resources.
- Once LAB is launched, grab the **Management Node IP**, **Username** and **Password** from **Addl. Info** tab on Right Side


### Accessing the LAB

All of the information you need to access your test drive lab instances is available via the **Addl. Info** tab to the right. There you will find relevant public IP addresse, username, and password for your personal lab environment.

!!! note
    - If the **Addl. Info** Tab is unavailable, make sure you clicked **Start Lab** button on the top bar of interface.
    - After clicking **Start Lab** , Lab creation will take some **12-15 minutes**. This is expected,  so Hang Tight.

- Open SSH client software on your workstation.
- As **ceph** user, SSH into Ceph Management node by using the **Management node IP address** which you can get from the **Addl. Info** tab.
- SSH into the node using the following command and provided credentials
  - ``$ ssh ceph@<Mangement Node IP Address>``
  - **Login Credentials** ⇒ **User Name:** **ceph** and **Password:** **Redhat16**

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

!!! note
    - ** If your SSH connection fails , do the following : ** 
    - Select the CONNECTION tab from the main lab page 
    - Select the Download PEM/PPK button
    - Select Download PEM , note the download location of the PEM file and execute the following
    - ssh -i absolute-path-of-pem-file ceph@Management-node-ip-address 

### Terminating the LAB

Follow these steps to end your lab environment and share your experience.

- Close your remote session.
- In the *qwik*LABS page, click **End Lab**.
- In the confirmation message, click **OK**.
- Tell us about your lab experiences and suggestions to improve this environment

## RHCS Prerequisites
Setting up a RHCS requires the following configuration on the cluster nodes.

- **Operating System :**  Supported version of OS.
- **Registration to RHN :** To get necessary packages required for installation either from RHN (Red Hat Network) or other trusted sources.
- **Enabling Ceph Repositories :** To get Ceph packages from CDN or from Local repositories.
- **Separate networks :** For Public and Cluster traffic.
- **Setting hostname resolutions :** Either local or DNS name resolution 
- **Configuring firewall :**  Allow necessary port to be opened.
- **NTP configuration:** For time synchronization across nodes.
- **Local user account:** User with passwordless sudo ssh access to all nodes, required for Ceph deployment using Ansible.

!!! note
    The purpose of Red Hat Ceph Storage Test Drive is to provide you an environment where you can focus on learning this great technology, without spending any time in fulfilling prerequisites. All the prerequisites listed above have been taken care for rest of this course.


> So without further delay, let's go ahead and follow the modules to gain experience on Ceph.

