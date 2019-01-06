# Setting PHP-FPM user to nginx

username= # Define username here

useradd $username
usermod -a -G nginx $username
id $username
su -c "mkdir /home/$username/public_html" $username
chgrp nginx /home/$username/public_html
chmod g+rwxs /home/$username/public_html

su -c 'cat /dev/zero | ssh-keygen -t ed25519 -q -N ""' $username
su -c "cp /home/$username/.ssh/id_ed25519.pub /home/$username/.ssh/authorized_keys" $username
chmod 600 /home/$username/.ssh/authorized_keys

chgrp nginx /home/$username
chmod g+rwx /home/$username

cat > /etc/nginx/conf.d/$username.conf <<EOF
server {
    listen       443 ssl http2;
    listen       [::]:443 ssl http2;
    server_name  $username.com www.$username.com;
    root         /home/$username/public_html;

    ssl_certificate "/root/.acme.sh/$username.com_ecc/fullchain.cer";
    ssl_certificate_key "/root/.acme.sh/$username.com_ecc/$username.com.key";

    include ssl_config;
    include wordpress_config;

    add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload";
}
EOF

yum install certbot -y

# Temporary solution, you should first move the old certificate to here for testing purpose
mkdir -p /etc/letsencrypt/live/$username
touch /etc/letsencrypt/live/$username/fullchain.pem
touch /etc/letsencrypt/live/$username/privkey.pem
