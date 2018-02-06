cd /root
mkdir aead
cd aead
yum update -y
yum groupinstall "Development Tools" -y
yum install rng-tools gettext gcc autoconf libtool automake make asciidoc xmlto c-ares-devel udns-devel libev-devel -y
yum install epel-release -y
yum install gcc gettext autoconf libtool automake make pcre-devel asciidoc xmlto udns-devel libev-devel libsodium-devel mbedtls-devel -y
git clone https://github.com/shadowsocks/shadowsocks-libev.git
cd shadowsocks-libev
git submodule update --init --recursive
yum install wget -y
export LIBSODIUM_VER=1.0.13
wget https://download.libsodium.org/libsodium/releases/libsodium-$LIBSODIUM_VER.tar.gz
tar xvf libsodium-$LIBSODIUM_VER.tar.gz
pushd libsodium-$LIBSODIUM_VER
./configure --prefix=/usr && make
make install
popd
ldconfig
export MBEDTLS_VER=2.5.1
wget https://tls.mbed.org/download/mbedtls-$MBEDTLS_VER-gpl.tgz
tar xvf mbedtls-$MBEDTLS_VER-gpl.tgz
pushd mbedtls-$MBEDTLS_VER
make SHARED=1 CFLAGS=-fPIC
make DESTDIR=/usr install
popd
ldconfig
wget https://download.libsodium.org/libsodium/releases/LATEST.tar.gz
tar xzvf LATEST.tar.gz
cd libsodium*
./configure
make -j8 && make install
echo /usr/local/lib > /etc/ld.so.conf.d/usr_local_lib.conf
ldconfig
cd ..
./autogen.sh && ./configure --with-sodium-include=/usr/local/include --with-sodium-lib=/usr/local/lib --with-mbedtls-include=/usr/local/include --with-mbedtls-lib=/usr/local/lib && make
make install
echo "Enter you ip now:"
read ip
echo "Your server port pls:"
read port
echo "And Password:"
read psw
cat > /etc/shadowsocks.json <<EOF
{
    "server":"$ip",
    "server_port":$port,
    "local_port":8366,
    "password":"$psw",
    "timeout":120,
    "method":"chacha20-ietf-poly1305"
}
EOF
chmod +x /etc/rc.d/rc.local
cat >> /etc/rc.d/rc.local <<EOF
cd /root && nohup ss-server -c /etc/shadowsocks.json > /dev/null 2>&1 &
EOF
echo "Shadowsocks bootup initialization finished."
read -p "Do you want to run it now? (Y/N)" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    cd /root && nohup ss-server -c /etc/shadowsocks.json > /dev/null 2>&1 &
fi
