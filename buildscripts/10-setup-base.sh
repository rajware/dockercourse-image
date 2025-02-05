#!/bin/sh -e

echo "Enabling community repository..."
sed -i -e 's/^#\(.*\/v.*\/community\)$/\1/g' /etc/apk/repositories

echo "Installing software..."
apk update && \
    apk add sudo curl bash bash-completion \
            docker docker-cli docker-cli-compose docker-cli-buildx

echo "Adding wheel group sudo permissions..."
echo "%wheel ALL=(ALL:ALL) ALL" > /etc/sudoers.d/20-matsya

echo "Adding user1 to docker group..."
adduser user1 docker

echo "Changing user1 full name and login shell"
sed -i -e 's/^\(user1:.*:\d*:\d*:\)User1\(:.*:\)\/bin\/sh$/\1User 1\2\/bin\/bash/' \
       /etc/passwd

echo "Adding docker to start..."
rc-update add docker

echo "Changing passwords..."
printf "root:Pass@word1\nuser1:Pass@word1" | chpasswd
