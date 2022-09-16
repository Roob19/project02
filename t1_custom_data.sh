#!/bin/bash
sudo apt-get update
sudo apt-get install apache2 php php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip php-fpm php-mysql libapache2-mod-php -y
sudo wget http://wordpress.org/latest.tar.gz -P /data/wordpress
tar xzvf /data/wordpress/latest.tar.gz -C /var/www/html/ --strip-components=1
cp /tmp/wp-config.php /var/www/html/wp-config.php
sudo rm -f /var/www/html/index.html
sudo service apache2 reload