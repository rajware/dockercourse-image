# Answer file for Matsya image

# Use US layout with US variant
KEYMAPOPTS="us us"

# Set hostname to 'matsya'
HOSTNAMEOPTS=matsya

# Set device manager to mdev
DEVDOPTS=mdev

# Contents of /etc/network/interfaces
INTERFACESOPTS="auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp
    hostname matsya
"

# Search domain of example.com, Google public nameserver
# DNSOPTS="-d example.com 8.8.8.8"

# Set timezone to UTC
#TIMEZONEOPTS="UTC"
TIMEZONEOPTS="-i Asia/Kolkata"

# set http/ftp proxy
#PROXYOPTS="http://webproxy:8080"
PROXYOPTS=none

# Add first mirror (CDN)
# "-1" means use first mirror
APKREPOSOPTS="-1"

# Create user 'user1'
USEROPTS='-a -u -f User1 -g audio,video,netdev user1'

# Install Openssh
SSHDOPTS=openssh
# ROOTSSHKEY="<public key string>"
# Eg.:-
# ROOTSSHKEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICYz/pxcHLJamOU969GS+5Mca1gFhNuo96c2r/81Umbg root@matsya"
ROOTSSHKEY="${publickey}"

# Use chrony for NTP
# NTPOPTS="openntpd"
NTPOPTS=chrony

# Use /dev/sda as a sys disk
DISKOPTS="-m sys /dev/sda"
# DISKOPTS=none

# Setup storage with label APKOVL for config storage
# LBUOPTS="LABEL=APKOVL"
# LBUOPTS=none

# APKCACHEOPTS="/media/LABEL=APKOVL/cache"
# APKCACHEOPTS=none
