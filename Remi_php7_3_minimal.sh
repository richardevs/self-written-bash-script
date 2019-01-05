wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
wget http://rpms.remirepo.net/enterprise/remi-release-7.rpm
rpm -Uvh remi-release-7.rpm epel-release-latest-7.noarch.rpm
rm -f epel-release-latest-7.noarch.rpm
rm -f remi-release-7.rpm
yum install yum-utils -y
yum-config-manager --enable remi-php73
yum install php php-fpm php-opcache php-mysqlnd -y

systemctl enable php-fpm
