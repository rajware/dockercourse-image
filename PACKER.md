# Packer Build Instructions

The images for this repository can be built using HashiCorp [Packer](https://www.packer.io/).

## Build Prerequisites

1. Oracle VirtualBox, version 6.0 or above. The `VBoxManage` tool must be on the path.
2. HashiCorp Packer, version 1.8.3 or above.
3. An Alpine Linux "virtual" ISO image. This has to be downloaded into a folder named `iso` in this directory, and its name and checksum updated in the `matsya.pkr.hcl` file.

## Build Instructions

1. Create a folder named `iso` in the current directory.
2. Download an Alpine Linux "virtual" ISO file into this directory.
3. Update the file `matsya.pkr.hcl` with the path and checksum of this file.
4. Create a directory named `keys` in the current directory. Generate a key pair file named `rootcert` in it, for example by running `ssh-keygen -C root@matsya -t ed25519 -f keys/rootcert` in this directory.
5. Run `packer build matsya.pkr.hcl`. 


## Makefile

The steps described above can also be performed via a supplied makefile and GNU make.
`make keys` and `make vbox` can be used.

## Invoke-Build

An [Invoke-Build](https://github.com/nightroman/Invoke-Build) is also available. `Invoke-Build keys` and `Invoke-Build vbox` can be used, instead of GNU make.
