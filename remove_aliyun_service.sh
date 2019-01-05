wget http://update.aegis.aliyun.com/download/uninstall.sh
chmod +x uninstall.sh
./uninstall.sh
rm -f uninstall.sh

systemctl stop aliyun.service
systemctl disable aliyun.service
rm -f /etc/systemd/system/aliyun.service
rm -f /usr/sbin/aliyun-service
systemctl daemon-reload

chkconfig agentwatch off
chkconfig --del agentwatch
rm -f /etc/init.d/agentwatch

systemctl reboot
