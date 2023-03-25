# Project-6

WEB SOLUTION WITH WORDPRESS
=========

In this project you will be tasked to prepare storage infrastructure on two Linux servers and implement a basic web solution using WordPress. WordPress is a free and open-source content management system written in PHP and paired with MySQL or MariaDB as its backend Relational Database Management System (RDBMS).
Project 6 consists of two parts:
1. Configure storage subsystem for Web and Database servers based on Linux OS. The focus of this part is to give you practical experience of working with disks, partitions and volumes in Linux.
2. Install WordPress and connect it to a remote MySQL database server. This part of the project will solidify your skills of deploying Web and DB tiers of Web solution.

As a DevOps engineer, your deep understanding of core components of web solutions and ability to troubleshoot them will play essential role in your further progress and development.

## Three-tier Architecture

Generally, web, or mobile solutions are implemented based on what is called the Three-tier Architecture.

**Three-tier Architecture** is a client-server software architecture pattern that comprise of 3 separate layers.
![Screenshot (93)](https://user-images.githubusercontent.com/111396874/227518781-84597f34-4a00-4525-886b-29289d5e20b1.png)

1. **Presentation Layer** (PL): This is the user interface such as the client server or browser on your laptop.
2. **Business Layer** (BL): This is the backend program that implements business logic. Application or Webserver
3. **Data Access or Management Layer** (DAL): This is the layer for computer data storage and data access. Database Server or File System Server such as FTP server, or NFS Server

In this project, you will have the hands-on experience that showcases Three-tier Architecture while also ensuring that the disks used to store files on the Linux servers are adequately partitioned and managed through programs such as gdisk and LVM respectively.
You will be working working with several storage and disk management concepts, to have a better understanding, watch following video:
Disk management in Linux

Note: We are gradually introducing new AWS elements into our solutions, but do not be worried if you do not fully understand AWS Cloud Services yet, there are Cloud focused projects ahead where we will get into deep details of various Cloud concepts and technologies – not only AWS, but other Cloud Service Providers as well.

**Your 3-Tier Setup**

1. A Laptop or PC to serve as a client
2. An EC2 Linux Server as a web server (This is where you will install WordPress)
3. An EC2 Linux server as a database (DB) server

Use **RedHat OS** for this project

By now you should know how to spin up an EC2 instanse on AWS, but if you forgot – refer to Project1 Step 0.

In previous projects we used ‘Ubuntu’, but it is better to be well-versed with various Linux distributions, thus, for this projects we will use very popular distribution called ‘RedHat’ (it also has a fully compatible derivative – CentOS)
Note: for Ubuntu server, when connecting to it via SSH/Putty or any other tool, we used ubuntu user, but for RedHat you will need to use ec2-user user. Connection string will look like ec2-user@<Public-IP>

Let us get started!
  
## LAUNCH AN EC2 INSTANCE THAT WILL SERVE AS “WEB SERVER”.
### Step 1 — Prepare a Web Server'

1. Launch an EC2 instance that will serve as "Web Server". Create 3 volumes in the same AZ as your Web Server EC2, each of 10 GiB and attach them to the "Web Server"
![Screenshot (94)](https://user-images.githubusercontent.com/111396874/227520780-26e15786-726a-48c0-9e91-7dc0a8bffe77.png)
![Screenshot (95)](https://user-images.githubusercontent.com/111396874/227520810-08e144f3-0d3c-499e-8209-9652ddb10ed0.png)

2. Open up the Linux terminal to begin configuration
3. Use ``lsblk`` command to inspect what block devices are attached to the server. Notice names of your newly created devices. All devices in Linux reside in /dev/ directory. Inspect it with ls /dev/ and make sure you see all 3 newly created block devices there – their names will likely be xvdf, xvdh, xvdg.![Screenshot (96)](https://user-images.githubusercontent.com/111396874/227718962-3ec6ce11-faa5-4fbf-a673-c37637e86238.png)
4. Use ``df -h`` command to see all mounts and free space on your server
5. Use ``gdisk`` utility to create a single partition on each of the 3 disks
```
sudo gdisk /dev/xvdf
```
![Screenshot (99)](https://user-images.githubusercontent.com/111396874/227719087-7fddc899-9dee-4e1a-aab4-c50bf512fe80.png)
6. Use ``lsblk`` utility to view the newly configured partition on each of the 3 disks.
![Screenshot (98)](https://user-images.githubusercontent.com/111396874/227719126-3dd925b1-facb-4f63-8e2f-79852f1e7369.png)

7. Install lvm2 package using ``sudo yum install lvm2``.Run ``sudo lvmdiskscan`` command to check for available partitions.

**Note**: Previously, in Ubuntu we used apt command to install packages, in RedHat/CentOS a different package manager is used, so we shall use yum command instead.

8. Use ``pvcreate`` utility to mark each of 3 disks as physical volumes (PVs) to be used by LVM
```
sudo pvcreate /dev/xvdf1
sudo pvcreate /dev/xvdg1
sudo pvcreate /dev/xvdh1
```
9. Verify that your Physical volume has been created successfully by running ``sudo pvs``![verify pvs](https://user-images.githubusercontent.com/111396874/227719243-afded634-2958-4c51-ab50-08a9530e40ae.png)

10. Use ``vgcreate`` utility to add all 3 PVs to a volume group (VG). Name the VG **webdata-vg**
```
sudo vgcreate webdata-vg /dev/xvdh1 /dev/xvdg1 /dev/xvdf1
```
11. Verify that your VG has been created successfully by running ``sudo vgs``![Screenshot (100)](https://user-images.githubusercontent.com/111396874/227719349-2095eae3-80b0-4002-9334-7d0e881f76d4.png)

12. Use lvcreate utility to create 2 logical volumes. apps-lv (Use half of the PV size), and logs-lv Use the remaining space of the PV size. NOTE: apps-lv will be used to store data for the Website while, logs-lv will be used to store data for logs.
```
sudo lvcreate -n apps-lv -L 14G webdata-vg
sudo lvcreate -n logs-lv -L 14G webdata-vg
```

13. Verify that your Logical Volume has been created successfully by running ``sudo lvs``
![Screenshot (101)](https://user-images.githubusercontent.com/111396874/227719670-e17760fd-91d8-4624-aff0-7a5f01fef712.png)
14. Verify the entire setup
```
sudo vgdisplay -v #view complete setup - VG, PV, and LV
sudo lsblk 
```
![Screenshot (102)](https://user-images.githubusercontent.com/111396874/227719704-379e3bf0-95df-417c-8083-e8d3dadde657.png)
15. Use ``mkfs.ext4`` to format the logical volumes with ext4 filesystem
```
sudo mkfs -t ext4 /dev/webdata-vg/apps-lv
sudo mkfs -t ext4 /dev/webdata-vg/logs-lv
```
16. Create **/var/www/html** directory to store website files
```
sudo mkdir -p /var/www/html
```
17. Create **/home/recovery/logs** to store backup of log data

sudo mkdir -p /home/recovery/logs
18. Mount /var/www/html on apps-lv logical volume
```
sudo mount /dev/webdata-vg/apps-lv /var/www/html/
```
19. Use ``rsync`` utility to back up all the files in the log directory **/var/log** into **/home/recovery/logs** (This is required before mounting the file system)
```
sudo rsync -av /var/log/. /home/recovery/logs/
```
20. Mount **/var/log** on **logs-lv** logical volume. (Note that all the existing data on /var/log will be deleted. That is why step 15 above is very
important)
```
sudo mount /dev/webdata-vg/logs-lv /var/log
```
21. Restore log files back into **/var/log** directory
```
sudo rsync -av /home/recovery/logs/. /var/log
```
22. Update **/etc/fstab** file so that the mount configuration will persist after restart of the server.












  
