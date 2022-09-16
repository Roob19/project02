#!/bin/bash

sudo ufw enable -y

sudo ufw allow 80/tcp

sudo ufw allow 3306/tcp

sudo apt update && apt upgrade

sudo apt install apache2 -y

apt install php php-mysql

sudo apt install mysql-server

sudo systemctl start mysql.service

sudo mysql

ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';

sudo mysql

mysql -u root -p

CREATE DATABASE wordpress_db;

CREATE USER wordpress@team2proj2sql IDENTIFIED BY 'Password1234';

GRANT CREATE, ALTER, DROP, INSERT, UPDATE, DELETE, SELECT, REFERENCES, RELOAD on *.* TO wordpress@team2proj2sql WITH GRANT OPTION;

FLUSH PRIVILEGES;

exit

vim /var/www/html/info.php

<?php

phpinfo();

?>

cd /tmp && wget https://wordpress.org/latest.tar.gz

tar -xvf latest.tar.gz

cp -R wordpress /var/www/html/

chown -R www-data:www-data /var/www/html/wordpress/

chmod -R 755 /var/www/html/wordpress/

mkdir /var/www/html/wordpress/wp-content/uploads

chown -R www-data:www-data /var/www/html/wordpress/wp-content/uploads/

#wp post create --post_status=publish --post_title="It works!"

wp post generate