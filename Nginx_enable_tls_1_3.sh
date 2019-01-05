openssl_version=1.1.1a
nginx_version=1.15.8

yum -y install pcre-devel zlib-devel

wget https://www.openssl.org/source/openssl-$openssl_version.tar.gz
wget http://nginx.org/download/nginx-$nginx_version.tar.gz

tar xvf nginx-$nginx_version.tar.gz
tar xvf openssl-$openssl_version.tar.gz

cd nginx-$nginx_version
./configure --with-openssl=/root/openssl-1.1.1a --with-openssl-opt='enable-ec_nistp_64_gcc_128 enable-tls1_3' --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --modules-path=/usr/lib64/nginx/modules --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock --http-client-body-temp-path=/var/cache/nginx/client_temp --http-proxy-temp-path=/var/cache/nginx/proxy_temp --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp --http-scgi-temp-path=/var/cache/nginx/scgi_temp --user=nginx --group=nginx --with-compat --with-file-aio --with-threads --with-http_addition_module --with-http_auth_request_module --with-http_dav_module --with-http_flv_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_mp4_module --with-http_random_index_module --with-http_realip_module --with-http_secure_link_module --with-http_slice_module --with-http_ssl_module --with-http_stub_status_module --with-http_sub_module --with-http_v2_module --with-mail --with-mail_ssl_module --with-stream --with-stream_realip_module --with-stream_ssl_module --with-stream_ssl_preread_module --with-cc-opt='-O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector-strong --param=ssp-buffer-size=4 -grecord-gcc-switches -m64 -mtune=generic -fPIC' --with-ld-opt='-Wl,-z,relro -Wl,-z,now -pie'

make && make install
cd
rm -f nginx-$nginx_version.tar.gz
rm -rf nginx-$nginx_version
rm -f openssl-$openssl_version.tar.gz
rm -rf openssl-$openssl_version
