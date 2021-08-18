Tipi preinstalled on Windows Server 2016 (on Azure)
===================================================

How to build
------------

```powershell
# Azure credentials / env config
PS > $env:ARM_CLIENT_ID = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxxx"
PS > $env:ARM_CLIENT_SECRET = "yxz"
PS > $env:ARM_SUBSCRIPTION_ID = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxxx"
PS > $env:ARM_TENANT_ID = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxxx"
PS > $env:ARM_RESOURCE_GROUP = "image-ressource-group-name" # must exist
PS > $env:ARM_BUILD_RESOURCE_GROUP = "build-environment-ressource-group-name" # must exist
PS > $env:ARM_IMAGE_NAME = "target-image-name"

# now running packer
PS > packer build -force .\windowsserver2016-azure.json
```

> NOTE: this takes about 18minutes to complete on a *Standard_D4d_v4* as configured

What's inside?
--------------

- installed:
  - Nuget (used to install further stuff)
  - OpenSSH server
  - VCResitributables (required to run `tipicli`)
  - tipi
- configuration:
  - disables Windows Update
  - disables Windows Defender (slow writes...)
  - hardens TLS config
  - updates the root certificate store
  - configures winrm api properly

There's a post-boot action scheduled that copies the `.tipi` folder on the C: drive to `TIPI_HOME_DIR` to offset the distro-pre-heat time to the build time instead of placing the burden on every VM launch.
This roughly reduces tipi first compile time from ~7minutes to about 1 minute post-boot.

We *want* to do this because the temp storage is **significantly** faster on the *Dnd_v4* machines on Azure (about 10-14x for random small file access)