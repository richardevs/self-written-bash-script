#!/bin/bash
# Usage:
#./init.sh username domain

username=$1

PASS=`pwgen -s 30 1`
PASSUSER=`pwgen -s 30 1`

dbpass=`pwgen -s 24 1`

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
CREATE DATABASE $username;
CREATE USER '$username'@'localhost' IDENTIFIED BY '$dbpass';
GRANT ALL PRIVILEGES ON $username.* TO '$username'@'localhost';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

echo "MySQL user created."
echo "PHP socket created."
echo "Username:   $1"
echo "Password:   $PASS"
echo "UserPass:   $PASSUSER"
