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

cat > /etc/nginx/conf.d/$username.conf <<EOF
server {
    listen       443 ssl http2;
    listen       [::]:443 ssl http2;
    server_name  $username.com www.$username.com;
    root         /home/$username/public_html;

    ssl_certificate "/etc/letsencrypt/live/$username.com/fullchain.pem";
    ssl_certificate_key "/etc/letsencrypt/live/$username.com/privkey.pem";

    include ssl_config;
    include wordpress_config;

    add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload";
}
EOF
