#!/bin/sh -e

echo "Setting up lxdm..."
apk add lxdm

echo "Configuring lxdm..."
sed -i -e 's/^# session=.*$/session=\/usr\/bin\/startxfce4/' \
        -e 's/^lang=1$/lang=0/' \
        -e 's/^bottom_pane=.*$/bottom_pane=0/' \
        -e 's/^bg=.*$/bg=\/usr\/share\/backgrounds\/matsya-background.jpeg/' \
        /etc/lxdm/lxdm.conf

echo "Adding lxdm to startup..."
rc-update add lxdm

echo "Setting up VirtualBox integration..."

cat >/usr/sbin/vbox-integration <<"ENDVBOXINTEGRATION"
#!/bin/sh
pgrep -fx "/usr/sbin/VBoxClient --clipboard" > /dev/null
if [ $? -ne 0 ] ; then
    /usr/sbin/VBoxClient --clipboard
fi
pgrep -fx "/usr/sbin/VBoxClient --draganddrop" > /dev/null
if [ $? -ne 0 ] ; then
    /usr/sbin/VBoxClient --draganddrop
fi
pgrep -fx "/usr/sbin/VBoxClient --vmsvga" > /dev/null
if [ $? -ne 0 ] ; then
    /usr/sbin/VBoxClient --vmsvga
fi
ENDVBOXINTEGRATION

chmod +x /usr/sbin/vbox-integration

printf "\n/usr/sbin/vbox-integration\n" >> /etc/lxdm/PreLogin
