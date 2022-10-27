#!/bin/sh -e

cat > /etc/matsya-release <<EOF_RELEASESTAMP
Matsya Image Version: ${VM_VERSION}
Alpine Linux Version: $(cat /etc/alpine-release)
Containerd Version: $(containerd -v | cut -f3 -d " ")
Docker Version: $(docker version -f 'v{{ .Client.Version }}')
Buildx Version: $(docker buildx version | cut -f2 -d " ")
Compose Version: v$(docker compose version --short)
EOF_RELEASESTAMP