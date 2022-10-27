#!/bin/sh

echo "Writing a big zero file and deleting it..."
dd if=/dev/zero of=zerofillfile bs=1G
sync
sleep 1
rm zerofillfile
sync
sleep 1
exit 0