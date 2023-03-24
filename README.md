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
3. Use ``lsblk`` command to inspect what block devices are attached to the server. Notice names of your newly created devices. All devices in Linux reside in /dev/ directory. Inspect it with ls /dev/ and make sure you see all 3 newly created block devices there – their names will likely be xvdf, xvdh, xvdg.

4. Use ``df -h`` command to see all mounts and free space on your server
5. Use ``gdisk`` utility to create a single partition on each of the 3 disks




  
