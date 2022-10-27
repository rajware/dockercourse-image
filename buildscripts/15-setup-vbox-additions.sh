#!/bin/sh -e

echo "Installing software..."
apk add virtualbox-guest-additions virtualbox-guest-additions-x11

echo "Adding user1 to vboxsf group..."
adduser user1 vboxsf

echo "Adding virtualbox-guest-additions to start..."
rc-update add virtualbox-guest-additions
