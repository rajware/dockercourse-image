param(
    $VersionMajor  = (property VERSION_MAJOR "7"),
    $VersionMinor  = (property VERSION_MINOR "1"),
    $BuildNumber   = (property BUILD_NUMBER  "0"),
    $PatchString   = (property PATCH_NUMBER  ""),
    $OSISOPath     = (property OS_ISO_PATH "iso/alpine-virt-3.21.2-x86_64.iso"),
    $OSISOChecksum = (property OS_ISO_CHECKSUM "sha256:e877549fb113ba93f89f3755742f3e5178ae66fb345bf6a74a9ddbe1e8bd2ec6")
)

$VersionString = "$($VersionMajor).$($VersionMinor).$($BuildNumber)$($PatchString)"

$VMDescription = @"
Matsya Image version $($VersionString)

Alpine base image: $($OSISOPath)
"@

# Synopsis: Show usage
task . {
    Write-Host "Usage: Invoke-Build vbox|hyperv|keys|clean-vbox|clean-hyperv|clean-keys|clean"
}

# Synopsis: Build VirtualBox image
task vbox -Outputs "output-matsya-vbox/Matsya-$($VersionString).ova" -Inputs matsya-vbox.pkr.hcl keys, {
    exec {
        packer build `-only=matsya-vm.virtualbox-iso.matsya-vbox `-var "iso-url=$($OSISOPath)" `-var "iso-checksum=$($OSISOChecksum)" `-var "vm-version=$($VersionString)" `-var "vm-description=$($VMDescription)" matsya-vbox.pkr.hcl
    }
}

# Synopsis: Build HyperV image
task hyperv -Outputs "output-matsya-hyperv/matsya-hyperv.zip" -Inputs matsya-hyperv.pkr.hcl keys, {
    exec {
        packer build `-var "iso-url=$($OSISOPath)" `-var "iso-checksum=$($OSISOChecksum)" `-var "vm-version=$($VersionString)" `-var "vm-description=$($VMDescription)" matsya-hyperv.pkr.hcl
    }
}

# Synopsis: Create key pair
task keys -Outputs keys/rootcert.pub -If (-not (Test-Path keys/rootcert)) {
    New-Item -Path keys/ -ItemType Directory -ErrorAction Ignore
    Set-Location -Path keys/
    exec {
        ssh-keygen -C root@matsya -t ed25519 -f rootcert
    }
}

# Synopsis: Delete built VirtualBox image
task clean-vbox {
    Remove-Item -Recurse -Force output-matsya-vbox -ErrorAction Ignore
}

# Synopsis: Delete built Hyper-V image
task clean-hyperv {
    Remove-Item -Recurse -Force output-matsya-hyperv -ErrorAction Ignore
}

# Synopsis: Delete key pair
task clean-keys {
    Remove-Item -Recurse -Force keys -ErrorAction Ignore
}

# Synopsis: Delete all output
task clean clean-vbox, clean-hyperv, clean-keys
