#!/bin/bash
# Usage:
#./init.sh username domain

PASS=`pwgen -sy 30 1`
PASSUSER=`pwgen -sy 30 1`

groupadd $1
useradd -g $1 $1
echo $PASSUSER | passwd --stdin $1
cp /etc/php-fpm.d/www.conf /etc/php-fpm.d/$1.conf
sed -i "s/replacehere/$1/g" /etc/php-fpm.d/$1.conf
sudo -u $1 mkdir /home/$1/public_html
cp /etc/nginx/conf.d/copythis /etc/nginx/conf.d/$2.conf
sed -i "s/replacehere/$1/g" /etc/nginx/conf.d/$2.conf
sed -i "s/domain/$2/g" /etc/nginx/conf.d/$2.conf

mysql -u root -p <<MYSQL_SCRIPT
CREATE DATABASE $1;
CREATE USER '$1'@'localhost' IDENTIFIED BY '$PASS';
GRANT ALL PRIVILEGES ON $1.* TO '$1'@'localhost';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

echo "MySQL user created."
echo "PHP socket created."
echo "Username:   $1"
echo "Password:   $PASS"
echo "UserPass:   $PASSUSER"
