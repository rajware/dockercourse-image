#!/bin/sh -e

echo "Installing xrdp and xorgxrdp..."
apk add xrdp xorgxrdp

echo "Adding xrdp and xrdp-sesman to startup..."
rc-update add xrdp
rc-update add xrdp-sesman
