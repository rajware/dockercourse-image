# Before using this script, you need to obtain an alpine
# "virt" ISO, and put it in a folder called "iso".
# The iso name and its checksum should be updated here.
# The last build used alpine 3.18.3.
variable "iso-url" {
  # Location of the alpine virt iso
  type    = string
  default = "./iso/alpine-virt-3.18.3-x86_64.iso"
}

variable "iso-checksum" {
  # Checksum of the alpine virt iso
  type    = string
  default = "sha256:925f6bc1039a0abcd0548d2c3054d54dce31cfa03c7eeba22d10d85dc5817c98"
}

# You should also generate a key pair (using openssh for
# example), and save the corresponding files using the 
# name 'rootcert' and 'rootcert.pub' to a folder called
# "keys". If you change the filenames or the location,
# update the following:
variable "root-certificate" {
  # Path to key pair file used for identifying root user
  type    = string
  default = "keys/rootcert"
}

variable "root-public-key" {
  # Public key file of the key pair in root-certificate
  type    = string
  default = "keys/rootcert.pub"
}

variable "vm-version" {
  type    = string
  default = "latest"
}

variable "vm-description" {
  type    = string
  default = "Matsya Image"
}

source "virtualbox-iso" "matsya-vbox" {
  iso_url      = "${var.iso-url}"
  iso_checksum = "${var.iso-checksum}"

  # Create a VM with 
  #  - 2 cpu cores
  #  - 4 GiB RAM
  #  - 100 GiB hard disk
  cpus      = "2"
  memory    = "4096"
  disk_size = "102400"

  gfx_controller = "vmsvga"
  gfx_vram_size  = "16"

  # Optimize for 64-bit "Other" Linux
  guest_os_type = "Linux_64"

  # Guest additions will come from alpine repos
  guest_additions_mode = "disable"

  # HTTP serve the answer file
  # via a template, to which we pass the root public
  # key. Among other things, this will set up sshd
  # and allow the root user to connect using the SSH
  # key.
  http_content = {
    "/answerfile" = templatefile(
      "buildhttp/answerfile.pkrtpl.hcl",
      { publickey = file("${var.root-public-key}") }
    )
  }

  # After all provisioners have run, and the VM has
  # been stopped, the following VBoxManage commands
  # are carried out. The first one compacts the VDI
  # hard disk, the second turns Remote Display off,
  # the third one adds an icon to the image and the
  # last one forwards host port 50022 to guest port
  # 22. 
  vboxmanage_post = [
    [
      "modifyhd",
      "--compact",
      "output-matsya-vbox/{{ .Name }}.vdi"
    ],
    [
      "modifyvm",
      "{{ .Name }}",
      "--vrde",
      "off"
    ],
    [
      "modifyvm",
      "{{ .Name }}",
      "--iconfile",
      "attachments/icon/matsya.png"
    ],
    [
      "modifyvm",
      "{{.Name}}",
      "--natpf1",
      "SSH,tcp,,50022,,22"
    ]
  ]

  # Ensure that MAC addresses are stripped at export
  export_opts = [
    "--manifest",
    "--options", "nomacs",
    "--vsys", "0",
    "--description", "${var.vm-description}",
    "--version", "${var.vm-version}"
  ]

  format = "ova"

  # Set up a boot command for the Alpine Virt ISO.
  # Important aspects are:
  #   - ERASE_DISKS ensures no prompts during setup-disk
  #   - setup-alpine -e ensures no root password
  #   -              -f points to prefilled answer file
  # Also see the commented answer file to see what 
  # exactly gets configured.
  boot_wait = "15s"
  boot_command = [
    "<wait><wait>",
    "root<wait>",
    "<enter><wait>",
    "ERASE_DISKS=/dev/sda <wait>",
    "setup-alpine -e -f <wait>",
    "http://{{ .HTTPIP }}:{{ .HTTPPort }}/answerfile <wait>",
    "&& reboot <wait>",
    "|| echo Install failed! <wait>",
    "<enter><wait>"
  ]


  # All ssh connections will happen as root, using a key
  # specified.
  ssh_username         = "root"
  ssh_private_key_file = "${var.root-certificate}"
  ssh_timeout          = "20m"

  # There will be one reboot when the boot command
  # (setup-alpine) finishes. Unfortunately, the sshd
  # service starts before then. The following setting
  # will make packer immediately disconnect after the
  # first connection, and wait 1m before continuing
  # with the rest of the build.
  pause_before_connecting = "1m"

  # When all provisioners are done, the vm will be 
  # shut down using the following command.
  shutdown_command = "poweroff"

  # VirtualBox 7 requires this addition setting for accessing
  # the preseed file over http. Comment this out if using
  # VirtualBox 6.
  vboxmanage = [
    ["modifyvm", "{{.Name}}", "--nat-localhostreachable1", "on"],
  ]


  # The output file should be called Matsya.ova
  vm_name = "Matsya-${var.vm-version}"
}

build {
  name = "matsya-vm"
  sources = [
    "sources.virtualbox-iso.matsya-vbox"
  ]

  provisioner "file" {
    sources = [
      "attachments/filesystem/"
    ]

    destination = "/"
  }

  provisioner "shell" {
    expect_disconnect = true
    scripts = [
      "buildscripts/10-setup-base.sh",
      "buildscripts/20-setup-gui.sh",
      "buildscripts/30-setup-extlinux.sh",
      "buildscripts/40-stamp-release.sh"
    ]
    override = {
      matsya-vbox = {
        scripts = [
          "buildscripts/10-setup-base.sh",
          "buildscripts/15-setup-vbox-additions.sh",
          "buildscripts/20-setup-gui.sh",
          "buildscripts/25-setup-vbox-gui-integration.sh",
          "buildscripts/30-setup-extlinux.sh",
          "buildscripts/40-stamp-release.sh"
        ]
      }
    }
    # Ensure the VM_VERSION variable.
    environment_vars = [
      "VM_VERSION=${var.vm-version}"
    ]
  }
}
