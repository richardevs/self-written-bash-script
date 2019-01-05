# Setting PHP-FPM user to nginx

username= # Define username here

useradd $username
usermod -a -G nginx $username
id $username
su -c "mkdir /home/$username/public_html" $username
chgrp nginx /home/$username/public_html
chmod g+rwxs /home/$username/public_html

su -c 'cat /dev/zero | ssh-keygen -t ed25519 -q -N ""' $username
