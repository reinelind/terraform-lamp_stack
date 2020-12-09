#!/bin/bash
sudo yum update -y
sudo yum update -y
sudo yum install -y php
sudo yum install -y httpd 
sudo systemctl start httpd
sudo systemctl enable httpd
sudo usermod -a -G apache centos
sudo chown -R centos:apache /var/www
chmod 2775 /var/www
sudo find /var/www -type d -exec chmod 2775 {} \;
sudo find /var/www -type f -exec chmod 0664 {} \;
sudo echo "<?php phpinfo(); ?>" > /var/www/html/phpinfo.php