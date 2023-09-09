# dockercourse-image

VM image for the Rajware Docker course

![GitHub release (latest by date)](https://img.shields.io/github/v/release/rajware/dockercourse-image?include_prereleases)

This repository contains build instructions and Packer templates for building VM images for the Docker course conducted by Rajware. Images can be built for VirtualBox and Hyper-V.

Each image contains a self-contained Alpine Linux installation with XFCE, and the open-source Docker Engine.

The VirtualBox image includes a display manager (LXDM), and is intended to be used from the VirtualBox UI directly. It offers a full GUI, with host clipboard integration. 

The Hyper-V image does not include a display manager. It is intended to be used via an RDP connection (Windows Remote Desktop for example). It also offers, via the RDP client software, a full GUI with host clipboard integration.

## Building Images

Images can be built by manually following the instructions in [BUILDING.md](BUILDING.md), or by running the Packer script as detailed in [PACKER.md](PACKER.md).

## Keys

If the Packer script is used, a key pair has to be supplied as described in [PACKER.md](PACKER.md). Each release published in this repository uses a fresh key pair, which is discarded after the build.

<img src="attachments/icon/matsya.png" width="64" alt="Matsya Icon" title="Matsya Icon" />
