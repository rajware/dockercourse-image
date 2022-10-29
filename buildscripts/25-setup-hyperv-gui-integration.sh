#!/bin/sh -e

echo "Enabling testing repository..."
sed -i -e 's/^#\(.*\/v.*\/testing\)$/\1/g' /etc/apk/repositories

echo "Adding fbdev and vesa drivers"
apk update && apk add xf86-video-fbdev xf86-video-vesa

