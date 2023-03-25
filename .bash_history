sudo lvcreate -n apps-lv -L 14G webdata-vg
sudo lvcreate -n logs-lv -L 14G webdata-vg
sudo lvs
sudo vgdisplay -v #view complete setup - VG, PV, and LV
sudo lsblk 
sudo mkfs -t ext4 /dev/webdata-vg/apps-lv
sudo mkfs -t ext4 /dev/webdata-vg/logs-lv
sudo mkdir -p /var/www/html
sudo mkdir -p /home/recovery/logs
sudo mount /dev/webdata-vg/apps-lv /var/www/html/
sudo rsync -av /var/log/. /home/recovery/logs/
sudo mount /dev/webdata-vg/logs-lv /var/log
sudo rsync -av /home/recovery/logs/. /var/log
sudo blkid
sudo vi /etc/fstab
 sudo mount -a
 sudo systemctl daemon-reload
df -h
sudo yum -y install wget httpd php php-mysqlnd php-fpm php-json
sudo systemctl enable httpd
sudo systemctl start httpd
vi install.sh
sh install.sh 
sudo setsebool -P httpd_execmem 1
sudo systemctl restart httpd
vi wordp.sh
sh wordp.sh
vi wordp.sh
sh wordp.sh
ls
sudo rm -r install.sh 
  sudo chown -R apache:apache /var/www/html/wordpress
  sudo chcon -t httpd_sys_rw_content_t /var/www/html/wordpress -R
  sudo setsebool -P httpd_can_network_connect=1
	sudo setsebool -P httpd_can_network_connect_db 1
sudo yum install mysql-client
sudo yum install mysqlclient
sudo yum install mysql
mysql -u admin -p -h 172.31.26.84
mysql -u myuser -p -h 172.31.26.84
ls
ls wordpress/
cd wordpress
ls
cd wordpress/
ls
cd ..
cd
tree
sudo yuum install tree
sudo yum install tree
tree
ls /var/www/
systemctl status httpd
