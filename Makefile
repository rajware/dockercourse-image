VERSION_MAJOR ?= 8
VERSION_MINOR ?= 0
BUILD_NUMBER  ?= 0
PATCH_NUMBER  ?=
VERSION_STRING = $(VERSION_MAJOR).$(VERSION_MINOR).$(BUILD_NUMBER)$(PATCH_NUMBER)

OS_ISO_PATH ?= "iso/alpine-virt-3.21.2-x86_64.iso"
OS_ISO_CHECKSUM ?= "sha256:e877549fb113ba93f89f3755742f3e5178ae66fb345bf6a74a9ddbe1e8bd2ec6"

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
