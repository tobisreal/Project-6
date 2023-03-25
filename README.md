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
```
sudo mkdir -p /home/recovery/logs
```
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

##### UPDATING THE `/ETC/FSTAB` FILE
The UUID of the device will be used to update the **/etc/fstab** file;
```
sudo blkid
```
![Screenshot (104)](https://user-images.githubusercontent.com/111396874/227720595-b39ee217-5f01-4ad6-a3e6-f7fedc715f1f.png)
```
sudo vi /etc/fstab
```
Update **/etc/fstab** in this format **using your own UUID** and remember to remove the leading and ending quotes.
![Screenshot (105)](https://user-images.githubusercontent.com/111396874/227720659-12440dd1-c889-4b1d-937d-9b294e85d5e1.png)
* Test the configuration and reload the daemon
```
sudo mount -a
sudo systemctl daemon-reload
```
* Verify your setup by running ``df -h``, output must look like this:
![Screenshot (103)](https://user-images.githubusercontent.com/111396874/227720748-6403187c-084b-45b3-b667-a1c7566820f8.png)

### Step 2 — Prepare the Database Server

Launch a second RedHat EC2 instance that will have a role – ‘DB Server’
Repeat the same steps as for the Web Server, but instead of apps-lv create db-lv and mount it to /db directory instead of /var/www/html/.

### Step 3 — Install WordPress on your Web Server EC2
1. Update the repository
```
sudo yum -y update
```
2. Install wget, Apache and it’s dependencies
```
sudo yum -y install wget httpd php php-mysqlnd php-fpm php-json
```
3. Start Apache
```
sudo systemctl enable httpd
sudo systemctl start httpd
```
4. To install PHP and its depemdencies
```
sudo yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
sudo yum install yum-utils http://rpms.remirepo.net/enterprise/remi-release-8.rpm
sudo yum module list php
sudo yum module reset php
sudo yum module enable php:remi-7.4
sudo yum install php php-opcache php-gd php-curl php-mysqlnd
sudo systemctl start php-fpm
sudo systemctl enable php-fpm
setsebool -P httpd_execmem 1
```
5. Restart Apache
```
sudo systemctl restart httpd
```
6. Download wordpress and copy wordpress to var/www/html
```
mkdir wordpress
cd wordpress
sudo wget http://wordpress.org/latest.tar.gz
sudo tar xzvf latest.tar.gz
sudo rm -rf latest.tar.gz
cp wordpress/wp-config-sample.php wordpress/wp-config.php
cp -R wordpress /var/www/html/
```
7. Configure SELinux Policies
```
sudo chown -R apache:apache /var/www/html/wordpress
sudo chcon -t httpd_sys_rw_content_t /var/www/html/wordpress -R
sudo setsebool -P httpd_can_network_connect=1
sudo setsebool -P httpd_can_network_connect_db 1
```

### Step 4 — Install MySQL on your DB Server EC2
```
sudo yum update
sudo yum install mysql-server
```
Verify that the service is up and running by using sudo systemctl status mysqld, if it is not running, restart the service and enable it so it will be running even after reboot:
```
sudo systemctl restart mysqld
sudo systemctl enable mysqld
```
### Step 5 — Configure DB to work with WordPress
```
sudo mysql
CREATE DATABASE wordpress;
CREATE USER `myuser`@`<Web-Server-Private-IP-Address>` IDENTIFIED BY 'mypass';
GRANT ALL ON wordpress.* TO 'myuser'@'<Web-Server-Private-IP-Address>';
FLUSH PRIVILEGES;
SHOW DATABASES;
exit
```
### Step 6 — Configure WordPress to connect to the remote database.

Hint: Do not forget to open MySQL port 3306 on DB Server EC2. For extra security, you shall allow access to the DB server ONLY from your Web Server’s IP address, so in the Inbound Rule configuration specify source as /32
 
1. Install MySQL client and test that you can connect from your Web Server to your DB server by using mysql-client
```
sudo yum install mysql
sudo mysql -u myuser -p -h <DB-Server-Private-IP-address>
```
2. Verify if you can successfully execute ``SHOW DATABASES;`` command and see a list of existing databases.

3. Change permissions and configuration so Apache could use WordPress:

Below is a method of configuration of Apache for wordpress

* You need to configure Apache to serve WordPress. You can create a new virtual host file for WordPress in the ``/etc/httpd/conf.d/`` directory. Here's an of example configuration file:
```
sudo vi /etc/httpd/conf.d/wordpress.conf
```
```
<VirtualHost *:80>
  ServerName example.com
  DocumentRoot /var/www/html/
  <Directory /var/www/html/>
    AllowOverride All
    Require all granted
  </Directory>
</VirtualHost>
```
* Change permissions: You need to change the permissions of the WordPress files and directories so that Apache can read and write them. You can do this by running the following commands:
```
sudo chmod -R 755 /var/www/html/wordpress
```
* Restart Apache: After making the changes, you need to restart Apache to apply the new configuration:
```
sudo systemctl restart httpd
```
![Screenshot (109)](https://user-images.githubusercontent.com/111396874/227745751-e469b2e4-9689-4313-bea2-3f56954a7905.png)

4. Enable TCP port 80 in Inbound Rules configuration for your Web Server EC2 (enable from everywhere 0.0.0.0/0 or from your workstation’s IP)
5. Configure the ``wp-config.php`` file so that wordpress can conncet to the database without failing. Make sure that the **username**, **password**, **database name**, and **database host** in your **wp-config.php** file corresponds with database you created. You can find these details in the MySQL database that you created earlier.
```
sudo vi /var/www/html/wordpress/wp-config.php
```

Here is an example:
![Screenshot (114)](https://user-images.githubusercontent.com/111396874/227746007-07c85603-5db5-45a6-b834-5b15cc40e463.png)

6. Try to access from your browser the link to your WordPress ``http://<Web-Server-Public-IP-Address>/wordpress/``

If you see this message – it means your WordPress has successfully connected to your remote MySQL database
![Screenshot (110)](https://user-images.githubusercontent.com/111396874/227746259-7dafd29e-fb7d-4b42-b537-68121ffb47f0.png)
![Screenshot (111)](https://user-images.githubusercontent.com/111396874/227746271-c1b9a189-feee-4c2e-b32b-520b2186f36c.png)

**CONGRATULATIONS!**
You have learned how to configure Linux storage susbystem and have also deployed a full-scale Web Solution using WordPress CMS and MySQL RDBMS

















  
