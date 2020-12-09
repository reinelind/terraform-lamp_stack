#!/bin/bash
yum update -y
yum install -y php7.2 php7.2
yum install -y httpd 
systemctl start httpd
systemctl enable httpd
usermod -a -G apache centos
chown -R centos:apache /var/www
chmod 2775 /var/www
find /var/www -type d -exec chmod 2775 {} \;
find /var/www -type f -exec chmod 0664 {} \;
echo "<?php phpinfo(); ?>" > /var/www/html/phpinfo.php