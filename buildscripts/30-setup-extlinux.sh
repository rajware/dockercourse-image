#!/bin/sh -e

echo "Updating update-extlinux.conf..."
sed -i -e 's/^default_kernel_opts="\(.*\)"$/default_kernel_opts="\1 swapaccount=1"/g' \
       -e 's/^timeout=\d*$/timeout=1/' \
       /etc/update-extlinux.conf

echo "Running update-extlinux..."
update-extlinux
