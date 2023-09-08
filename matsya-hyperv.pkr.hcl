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

source "hyperv-iso" "matsya-hyperv" {
  iso_url      = "${var.iso-url}"
  iso_checksum = "${var.iso-checksum}"

  # Create a VM with 
  #  - 2 cpu cores
  #  - 4 GiB RAM
  #  - 100 GiB hard disk
  cpus      = "2"
  memory    = "4096"
  disk_size = "102400"

  generation = "2"

  # Guest additions will come from alpine repos
  guest_additions_mode = "none"

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
    "&& eject -s /dev/cdrom ",
    "&& reboot <wait>",
    "|| echo Install failed! <enter>",
    "<wait10><wait10><wait10><wait10><wait10><wait10>",
    "<wait10><wait10><wait10>",
    "root<enter><wait>",
    "apk add hvtools <wait>",
    "&& rc-service hv_fcopy_daemon start <wait>",
    "&& rc-service hv_kvp_daemon start <wait>",
    "&& rc-service hv_vss_daemon start <wait>",
    "<enter> <wait>",
    "exit <wait>",
    "<enter>"
  ]


  # All ssh connections will happen as root, using a key
  # specified.
  ssh_username         = "root"
  ssh_private_key_file = "${var.root-certificate}"
  ssh_timeout          = "20m"

  # When all provisioners are done, the vm will be 
  # shut down using the following command.
  shutdown_command = "poweroff"


  # The output file should be called Matsya-7.0.0
  vm_name = "Matsya-${var.vm-version}"

  # This sets the name of the switch to connect the VM.
  switch_name = "Default Switch"
}

build {
  name = "matsya-vm"
  sources = [
    "sources.hyperv-iso.matsya-hyperv"
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
        "buildscripts/15-setup-hyperv-services.sh",
        "buildscripts/20-setup-gui.sh",
        "buildscripts/25-setup-hyperv-gui-integration.sh",
        "buildscripts/40-stamp-release.sh"
    ]
    
    # Ensure the VM_VERSION variable.
    environment_vars = [
      "VM_VERSION=${var.vm-version}"
    ]
  }

  post-processor "compress" {
    output = "output-{{ .BuildName }}/{{ .BuildName }}.zip"
    keep_input_artifact = true
  }
}
