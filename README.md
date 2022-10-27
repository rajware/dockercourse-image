# dockercourse-image

VM image for the Rajware Docker course

![GitHub release (latest by date)](https://img.shields.io/github/v/release/rajware/dockercourse-image?include_prereleases)

This repository contains build instructions and a Packer script for building images for the Docker course conducted by Rajware

## Building Images

Images can be built by manually following the instructions in [BUILDING.md](BUILDING.md), or by running the Packer script as detailed in [PACKER.md](PACKER.md).

## Keys

If the Packer script is used, a key pair has to be supplied as described in [PACKER.md](PACKER.md). Each release published in this repository uses a fresh key pair, which is discarded after the build.

<img src="attachments/icon/matsya.png" width="64" alt="Matsya Icon" title="Matsya Icon" />
