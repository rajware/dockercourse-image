#!/bin/sh -e

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
