# Introduction

Welcome to Red Hat Ceph Storage Hands-on Lab. To make your Ceph experience awesome , the contents of this test drive have been divided into following modules.

- **Module 1 :** Setting up a Ceph cluster
- **Module 2 :** Accessing Ceph cluster via Block Storage interface
- **Module 3 :** Accessing Ceph cluster via Object Storage interface
<!-- - **Module 4 :** Scaling up a Ceph cluster -->

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



## Getting to know Red Hat Ceph Storage

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
