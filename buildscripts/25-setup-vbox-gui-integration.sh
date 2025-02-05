#!/bin/sh -e

echo "Setting up elogind..."
apk add elogind polkit-elogind xfce-polkit
rc-update add elogind

echo "Setting up VirtualBox integration..."

cat >/usr/sbin/vbox-display-integration <<"ENDVBOXINTEGRATION"
#!/bin/sh
pgrep -fx "/usr/sbin/VBoxClient --vmsvga" > /dev/null
if [ $? -ne 0 ] ; then
    /usr/sbin/VBoxClient --vmsvga
fi
ENDVBOXINTEGRATION

chmod +x /usr/sbin/vbox-display-integration

echo "Setting up lightdm..."
apk add lightdm lightdm-gtk-greeter

echo "Configuring lightdm..."
mkdir -p /etc/lightdm/lightdm.conf.d
cat >/etc/lightdm/lightdm.conf.d/50-matsya.conf <<"ENDLIGHTDMCONF"
[Seat:*]
allow-user-switching=false
display-setup-script=/usr/sbin/vbox-display-integration
ENDLIGHTDMCONF

cat >>/etc/lightdm/lightdm-gtk-greeter.conf <<"ENDGREETERCONF"

# Added by Rajware setup
background=/usr/share/backgrounds/matsya/matsya-background.jpeg
user-background=false
indicators=
ENDGREETERCONF

echo "Adding lighdm to startup..."
rc-update add lightdm
