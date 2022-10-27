param(
    $VersionMajor  = (property VERSION_MAJOR "7"),
    $VersionMinor  = (property VERSION_MINOR "0"),
    $BuildNumber   = (property BUILD_NUMBER  "0"),
    $PatchString   = (property PATCH_NUMBER  "-beta1"),
    $OSISOPath     = (property OS_ISO_PATH "iso/alpine-virt-3.16.2-x86_64.iso"),
    $OSISOChecksum = (property OS_ISO_CHECKSUM "md5:6e4443010ae82b2ba98fef801a7ec2b8")
)

$VersionString = "$($VersionMajor).$($VersionMinor).$($BuildNumber)$($PatchString)"

$VMDescription = @"
Matsya Image version $($VersionString)

Alpine base image: $($OSISOPath)
"@

# Synopsis: Show usage
task . {
    Write-Host "Usage: Invoke-Build vbox|keys|clean-vbox|clean-keys|clean"
}

# Synopsis: Build VirtualBox image
task vbox -Outputs "output-matsya-vbox/Matsya-$($VersionString).ova" -Inputs matsya.pkr.hcl keys, {
    exec {
        packer build `-only=matsya-vm.virtualbox-iso.matsya-vbox `-var "iso-url=$($OSISOPath)" `-var "iso-checksum=$($OSISOChecksum)" `-var "vm-version=$($VersionString)" `-var "vm-description=$($VMDescription)" matsya.pkr.hcl
    }
}

# Synopsis: Create key pair
task keys -Outputs keys/rootcert.pub -If (-not (Test-Path keys/rootcert)) {
    New-Item -Path keys/ -ItemType Directory -ErrorAction Ignore
    exec {
        ssh-keygen -C root@matsya -t ed25519 -f keys/rootcert
    }
}

# Synopsis: Delete built VirtualBox image
task clean-vbox {
    Remove-Item -Recurse -Force output-matsya-vbox -ErrorAction Ignore
}

# Synopsis: Delete key pair
task clean-keys {
    Remove-Item -Recurse -Force keys -ErrorAction Ignore
}


# Synopsis: Delete all output
task clean clean-vbox, clean-keys
