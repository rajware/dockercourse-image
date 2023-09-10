VERSION_MAJOR ?= 7
VERSION_MINOR ?= 0
BUILD_NUMBER  ?= 0
PATCH_NUMBER  ?=
VERSION_STRING = $(VERSION_MAJOR).$(VERSION_MINOR).$(BUILD_NUMBER)$(PATCH_NUMBER)

OS_ISO_PATH ?= "iso/alpine-virt-3.18.3-x86_64.iso"
OS_ISO_CHECKSUM ?= "sha256:925f6bc1039a0abcd0548d2c3054d54dce31cfa03c7eeba22d10d85dc5817c98"

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
	mkdir -p keys 2>/dev/null && cd ./keys && ssh-keygen -C root@matsya -t ed25519 -f rootcert

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
