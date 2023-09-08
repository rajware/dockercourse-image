VERSION_MAJOR ?= 7
VERSION_MINOR ?= 0
BUILD_NUMBER  ?= 0
PATCH_NUMBER  ?= -beta2
VERSION_STRING = $(VERSION_MAJOR).$(VERSION_MINOR).$(BUILD_NUMBER)$(PATCH_NUMBER)

OS_ISO_PATH ?= "iso/alpine-virt-3.16.2-x86_64.iso"
OS_ISO_CHECKSUM ?= "md5:6e4443010ae82b2ba98fef801a7ec2b8"

define VM_DESCRIPTION
Matsya Image version $(VERSION_STRING)

Alpine base image: $(OS_ISO_PATH)
endef
export VM_DESCRIPTION

.PHONY: usage
usage:
	@echo "Usage: make vbox|hyperv|keys|clean-vbox|clean-hyperv|clean-keys|clean"

output-matsya-vbox/Matsya.ova: matsya-vbox.pkr.hcl keys
	packer build \
		-var "iso-url=$(OS_ISO_PATH)" -var "iso-checksum=$(OS_ISO_CHECKSUM)" \
		-var "vm-version=$(VERSION_STRING)" -var "vm-description=$$VM_DESCRIPTION" $<

.PHONY: vbox
vbox: output-matsya-vbox/Matsya.ova

output-matsya-hyperv/matsya-hyperv.zip: matsya-hyperv.pkr.hcl keys
	packer build \
		-var "iso-url=$(OS_ISO_PATH)" -var "iso-checksum=$(OS_ISO_CHECKSUM)" \
		-var "vm-version=$(VERSION_STRING)" -var "vm-description=$$VM_DESCRIPTION" $<

.PHONY: hyperv
hyperv: output-matsya-hyperv/matsya-hyperv.zip

keys/rootcert:
	cd ./keys && ssh-keygen -C root@matsya -t ed25519 -f rootcert

keys/rootcert.pub: keys/rootcert

.PHONY: keys
keys: keys/rootcert.pub

.PHONY: clean-vbox
clean-vbox:
	rm -rf output-matsya-vbox

.PHONY: clean-hyperv
clean-hyperv:
	rm -rf output-matsya-hyperv

.PHONY: clean-keys
clean-keys:
	rm -rf keys/

.PHONY: clean
clean: clean-vbox clean-hyperv clean-keys
