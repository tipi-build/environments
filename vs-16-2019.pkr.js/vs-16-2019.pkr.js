{
    "variables": {
        "client_id": "{{env `ARM_CLIENT_ID`}}",
        "client_secret": "{{env `ARM_CLIENT_SECRET`}}",
        "subscription_id": "{{env `ARM_SUBSCRIPTION_ID`}}",
        "tenant_id": "{{env `ARM_TENANT_ID`}}",
        "object_id": "{{env `ARM_OBJECT_ID`}}",
        "resource_group": "{{env `ARM_RESOURCE_GROUP`}}",
        "storage_account": "{{env `ARM_STORAGE_ACCOUNT`}}",
        "temp_resource_group_name": "{{env `TEMP_RESOURCE_GROUP_NAME`}}",
        "location": "{{env `ARM_RESOURCE_LOCATION`}}",
        "virtual_network_name": "{{env `VNET_NAME`}}",
        "virtual_network_resource_group_name": "{{env `VNET_RESOURCE_GROUP`}}",
        "virtual_network_subnet_name": "{{env `VNET_SUBNET`}}",
        "private_virtual_network_with_public_ip": "{{env `PRIVATE_VIRTUAL_NETWORK_WITH_PUBLIC_IP`}}",
        "vm_size": "Standard_DS4_v2",
        "run_scan_antivirus": "false",
        "root_folder": "C:",
        "toolset_json_path": "{{env `TEMP`}}\\toolset.json",
        "image_folder": "C:\\image",
        "imagedata_file": "C:\\imagedata.json",
        "helper_script_folder": "C:\\Program Files\\WindowsPowerShell\\Modules\\",
        "psmodules_root_folder": "C:\\Modules",
        "install_user": "installer",
        "install_password": null,
        "capture_name_prefix": "packer",
        "image_version": "dev",
        "image_os": "win16"
    },
    "sensitive-variables": [
        "install_password",
        "client_secret"
    ],
    "builders": [
        {
            "name": "vhd",
            "type": "azure-arm",
            "client_id": "{{user `client_id`}}",
            "client_secret": "{{user `client_secret`}}",
            "subscription_id": "{{user `subscription_id`}}",
            "object_id": "{{user `object_id`}}",
            "tenant_id": "{{user `tenant_id`}}",
            "os_disk_size_gb": "256",
            "location": "{{user `location`}}",
            "vm_size": "{{user `vm_size`}}",
            "resource_group_name": "{{user `resource_group`}}",
            "storage_account": "{{user `storage_account`}}",
            "temp_resource_group_name": "{{user `temp_resource_group_name`}}",
            "capture_container_name": "images",
            "capture_name_prefix": "{{user `capture_name_prefix`}}",
            "virtual_network_name": "{{user `virtual_network_name`}}",
            "virtual_network_resource_group_name": "{{user `virtual_network_resource_group_name`}}",
            "virtual_network_subnet_name": "{{user `virtual_network_subnet_name`}}",
            "private_virtual_network_with_public_ip": "{{user `private_virtual_network_with_public_ip`}}",
            "os_type": "Windows",
            "image_publisher": "MicrosoftWindowsServer",
            "image_offer": "WindowsServer",
            "image_sku": "2016-Datacenter",
            "communicator": "winrm",
            "winrm_use_ssl": "true",
            "winrm_insecure": "true",
            "winrm_username": "packer"
        }
    ],
    "provisioners": [
        {
            "type": "powershell",
            "inline": [
                "New-Item -Path {{user `image_folder`}} -ItemType Directory -Force"
            ]
        },
        {
            "type": "file",
            "source": "{{ template_dir }}/scripts/ImageHelpers",
            "destination": "{{user `helper_script_folder`}}"
        },
        {
            "type": "file",
            "source": "{{ template_dir }}/scripts/SoftwareReport",
            "destination": "{{user `image_folder`}}"
        },
        {
            "type": "file",
            "source": "{{ template_dir }}/post-generation",
            "destination": "C:/"
        },
        {
            "type": "file",
            "source": "{{ template_dir }}/scripts/Tests",
            "destination": "{{user `image_folder`}}"
        },
        {
            "type": "file",
            "source": "{{template_dir}}/toolsets/toolset-2016.json",
            "destination": "{{user `toolset_json_path`}}"
        },
        {
            "type": "windows-shell",
            "inline": [
                "net user {{user `install_user`}} {{user `install_password`}} /add /passwordchg:no /passwordreq:yes /active:yes /Y",
                "net localgroup Administrators {{user `install_user`}} /add",
                "winrm set winrm/config/service/auth @{Basic=\"true\"}",
                "winrm get winrm/config/service/auth"
            ]
        },
        {
            "type": "powershell",
            "inline": [
                "if (-not ((net localgroup Administrators) -contains '{{user `install_user`}}')) { exit 1 }"
            ]
        },
        {
            "type": "powershell",
            "environment_vars": [
                "ImageVersion={{user `image_version`}}",
                "TOOLSET_JSON_PATH={{user `toolset_json_path`}}",
                "PSMODULES_ROOT_FOLDER={{user `psmodules_root_folder`}}"
            ],
            "scripts": [
                "{{ template_dir }}/scripts/Installers/Install-PowerShellModules.ps1",
                "{{ template_dir }}/scripts/Installers/Initialize-VM.ps1",
                "{{ template_dir }}/scripts/Installers/Install-WebPlatformInstaller.ps1"
            ],
            "execution_policy": "unrestricted"
        },
        {
            "type": "powershell",
            "scripts": [
                "{{ template_dir }}/scripts/Installers/Update-DotnetTLS.ps1",
                "{{ template_dir }}/scripts/Installers/Install-ContainersFeature.ps1"
            ]
        },
        {
            "type": "windows-restart",
            "restart_timeout": "30m"
        },
        {
            "type": "powershell",
            "inline": [
                "setx ImageVersion {{user `image_version` }} /m",
                "setx ImageOS {{user `image_os` }} /m"
            ]
        },
        {
            "type": "powershell",
            "environment_vars": [
                "IMAGE_VERSION={{user `image_version`}}",
                "IMAGEDATA_FILE={{user `imagedata_file`}}"
            ],
            "scripts": [
                "{{ template_dir }}/scripts/Installers/Update-ImageData.ps1",
                "{{ template_dir }}/scripts/Installers/Install-Docker.ps1",
                "{{ template_dir }}/scripts/Installers/Install-PowershellCore.ps1"
            ]
        },
        {
            "type": "windows-restart",
            "restart_timeout": "30m"
        },
        {
            "type": "powershell",
            "valid_exit_codes": [
                0,
                3010
            ],
            "environment_vars": [
                "TOOLSET_JSON_PATH={{user `toolset_json_path`}}"
            ],
            "scripts": [
                "{{ template_dir }}/scripts/Installers/Update-DockerImages.ps1",
                "{{ template_dir }}/scripts/Installers/Install-VS.ps1",
                "{{ template_dir }}/scripts/Installers/Install-NET48.ps1",
                "{{ template_dir }}/scripts/Installers/Windows2016/Install-SSDT.ps1"
            ],
            "elevated_user": "{{user `install_user`}}",
            "elevated_password": "{{user `install_password`}}"
        },
        {
            "type": "powershell",
            "environment_vars": [
                "TOOLSET_JSON_PATH={{user `toolset_json_path`}}"
            ],
            "scripts": [
                "{{ template_dir }}/scripts/Installers/Install-Nuget.ps1",
                "{{ template_dir }}/scripts/Installers/Install-Wix.ps1",
                "{{ template_dir }}/scripts/Installers/Install-WDK.ps1",
                "{{ template_dir }}/scripts/Installers/Install-Vsix.ps1"
            ]
        },
        {
            "type": "powershell",
            "scripts": [
                "{{ template_dir }}/scripts/Installers/Install-ServiceFabricSDK.ps1"
            ],
            "execution_policy": "remotesigned"
        },
        {
            "type": "windows-restart",
            "restart_timeout": "30m"
        },
        {
            "type": "powershell",
            "scripts": [
                "{{ template_dir }}/scripts/Installers/Install-AzureCli.ps1",
                "{{ template_dir }}/scripts/Installers/Install-AzureDevOpsCli.ps1",
                "{{ template_dir }}/scripts/Installers/Install-AzCopy.ps1",
                "{{ template_dir }}/scripts/Installers/Install-AzureDevSpacesCli.ps1",
                "{{ template_dir }}/scripts/Installers/Install-NodeLts.ps1",
                "{{ template_dir }}/scripts/Installers/Install-Bazel.ps1",
                "{{ template_dir }}/scripts/Installers/Install-7zip.ps1",
                "{{ template_dir }}/scripts/Installers/Install-AliyunCli.ps1",
                "{{ template_dir }}/scripts/Installers/Install-PostgreSQL.ps1",
                "{{ template_dir }}/scripts/Installers/Install-Packer.ps1",
                "{{ template_dir }}/scripts/Installers/Install-Pulumi.ps1",
                "{{ template_dir }}/scripts/Installers/Install-JavaTools.ps1"
            ]
        },
        {
            "type": "powershell",
            "environment_vars": [
                "TOOLSET_JSON_PATH={{user `toolset_json_path`}}",
                "ROOT_FOLDER={{user `root_folder`}}"
            ],
            "scripts": [
                "{{ template_dir }}/scripts/Installers/Install-Ruby.ps1",
                "{{ template_dir }}/scripts/Installers/Install-PyPy.ps1",
                "{{ template_dir }}/scripts/Installers/Install-Toolset.ps1",
                "{{ template_dir }}/scripts/Installers/Configure-Toolset.ps1",
                "{{ template_dir }}/scripts/Installers/Update-AndroidSDK.ps1",
                "{{ template_dir }}/scripts/Installers/Install-Pipx.ps1",
                "{{ template_dir }}/scripts/Installers/Install-PipxPackages.ps1"
            ]
        },
        {
            "type": "powershell",
            "scripts": [
                "{{ template_dir }}/scripts/Installers/Install-Sbt.ps1",
                "{{ template_dir }}/scripts/Installers/Install-OpenSSL.ps1",
                "{{ template_dir }}/scripts/Installers/Install-Perl.ps1",
                "{{ template_dir }}/scripts/Installers/Install-Git.ps1",
                "{{ template_dir }}/scripts/Installers/Install-GitHub-CLI.ps1",
                "{{ template_dir }}/scripts/Installers/Install-PHP.ps1",
                "{{ template_dir }}/scripts/Installers/Install-Rust.ps1",
                "{{ template_dir }}/scripts/Installers/Install-Julia.ps1",
                "{{ template_dir }}/scripts/Installers/Install-Svn.ps1",
                "{{ template_dir }}/scripts/Installers/Install-Chrome.ps1",
                "{{ template_dir }}/scripts/Installers/Install-Edge.ps1",
                "{{ template_dir }}/scripts/Installers/Install-Firefox.ps1",
                "{{ template_dir }}/scripts/Installers/Install-Selenium.ps1",
                "{{ template_dir }}/scripts/Installers/Install-IEWebDriver.ps1"
            ]
        },
        {
            "type": "powershell",
            "scripts": [
                "{{ template_dir }}/scripts/Installers/Enable-DeveloperMode.ps1"
            ],
            "elevated_user": "{{user `install_user`}}",
            "elevated_password": "{{user `install_password`}}"
        },
        {
            "type": "windows-shell",
            "inline": [
                "wmic product where \"name like '%%microsoft azure powershell%%'\" call uninstall /nointeractive"
            ]
        },
        {
            "type": "powershell",
            "environment_vars": [
                "TOOLSET_JSON_PATH={{user `toolset_json_path`}}",
                "PSMODULES_ROOT_FOLDER={{user `psmodules_root_folder`}}"
            ],
            "scripts": [
                "{{ template_dir }}/scripts/Installers/Install-AzureModules.ps1"
            ]
        },
        {
            "type": "powershell",
            "environment_vars": [
                "TOOLSET_JSON_PATH={{user `toolset_json_path`}}"
            ],
            "scripts": [
                "{{ template_dir }}/scripts/Installers/Install-VSWhere.ps1",
                "{{ template_dir }}/scripts/Installers/Install-WinAppDriver.ps1",
                "{{ template_dir }}/scripts/Installers/Install-Cmake.ps1",
                "{{ template_dir }}/scripts/Installers/Install-R.ps1",
                "{{ template_dir }}/scripts/Installers/Install-AWS.ps1",
                "{{ template_dir }}/scripts/Installers/Install-DACFx.ps1",
                "{{ template_dir }}/scripts/Installers/Install-MysqlCli.ps1",
                "{{ template_dir }}/scripts/Installers/Install-SQLPowerShellTools.ps1",
                "{{ template_dir }}/scripts/Installers/Install-DotnetSDK.ps1"
            ]
        },
        {
            "type": "powershell",
            "elevated_user": "SYSTEM",
            "elevated_password": "",
            "scripts": [
                "{{ template_dir }}/scripts/Installers/Install-Msys2.ps1"
            ]
        },
        {
            "type": "powershell",
            "scripts": [
                "{{ template_dir }}/scripts/Installers/Install-Mingw64.ps1",
                "{{ template_dir }}/scripts/Installers/Install-TypeScript.ps1",
                "{{ template_dir }}/scripts/Installers/Install-Haskell.ps1",
                "{{ template_dir }}/scripts/Installers/Install-Stack.ps1",
                "{{ template_dir }}/scripts/Installers/Install-Miniconda.ps1",
                "{{ template_dir }}/scripts/Installers/Install-AzureCosmosDbEmulator.ps1",
                "{{ template_dir }}/scripts/Installers/Install-Mercurial.ps1",
                "{{ template_dir }}/scripts/Installers/Install-Jq.ps1",
                "{{ template_dir }}/scripts/Installers/Install-Zstd.ps1",
                "{{ template_dir }}/scripts/Installers/Install-InnoSetup.ps1",
                "{{ template_dir }}/scripts/Installers/Install-GitVersion.ps1",
                "{{ template_dir }}/scripts/Installers/Install-NSIS.ps1",
                "{{ template_dir }}/scripts/Installers/Install-CloudFoundryCli.ps1",
                "{{ template_dir }}/scripts/Installers/Install-Vcpkg.ps1",
                "{{ template_dir }}/scripts/Installers/Install-KubernetesCli.ps1",
                "{{ template_dir }}/scripts/Installers/Install-Kind.ps1",
                "{{ template_dir }}/scripts/Installers/Install-MongoDB.ps1",
                "{{ template_dir }}/scripts/Installers/Install-GoogleCloudSDK.ps1",
                "{{ template_dir }}/scripts/Installers/Install-CodeQLBundle.ps1"
            ]
        },
        {
            "type": "powershell",
            "scripts": [
                "{{ template_dir }}/scripts/Installers/Install-WindowsUpdates.ps1",
                "{{ template_dir }}/scripts/Installers/Configure-DynamicPort.ps1"
            ],
            "elevated_user": "{{user `install_user`}}",
            "elevated_password": "{{user `install_password`}}"
        },
        {
            "type": "windows-restart",
            "restart_timeout": "30m"
        },
        {
            "type": "powershell",
            "scripts": [
                "{{ template_dir }}/scripts/Tests/RunAll-Tests.ps1"
            ],
            "environment_vars": [
                "TOOLSET_JSON_PATH={{user `toolset_json_path`}}",
                "PSMODULES_ROOT_FOLDER={{user `psmodules_root_folder`}}",
                "ROOT_FOLDER={{user `root_folder`}}"
            ]
        },
        {
            "type": "powershell",
            "inline": [
                "pwsh -File '{{user `image_folder`}}\\SoftwareReport\\SoftwareReport.Generator.ps1'"
            ],
            "environment_vars": [
                "TOOLSET_JSON_PATH={{user `toolset_json_path`}}"
            ]
        },
        {
            "type": "file",
            "source": "C:\\InstalledSoftware.md",
            "destination": "{{ template_dir }}/Windows2016-Readme.md",
            "direction": "download"
        },
        {
            "type": "powershell",
            "scripts": [
                "{{ template_dir }}/scripts/Installers/Finalize-VM.ps1"
            ]
        },
        {
            "type": "windows-restart",
            "restart_timeout": "30m"
        },
        {
            "type": "powershell",
            "environment_vars": [
                "RUN_SCAN_ANTIVIRUS={{user `run_scan_antivirus`}}"
            ],
            "scripts": [
                "{{ template_dir }}/scripts/Installers/Run-Antivirus.ps1"
            ]
        },
        {
            "type": "powershell",
            "scripts": [
                "{{ template_dir }}/scripts/Installers/Configure-Antivirus.ps1",
                "{{ template_dir }}/scripts/Installers/Disable-JITDebugger.ps1"
            ]
        },
        {
            "type": "powershell",
            "inline": [
                "if( Test-Path $Env:SystemRoot\\System32\\Sysprep\\unattend.xml ){ rm $Env:SystemRoot\\System32\\Sysprep\\unattend.xml -Force}",
                "& $env:SystemRoot\\System32\\Sysprep\\Sysprep.exe /oobe /generalize /quiet /quit",
                "while($true) { $imageState = Get-ItemProperty HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Setup\\State | Select ImageState; if($imageState.ImageState -ne 'IMAGE_STATE_GENERALIZE_RESEAL_TO_OOBE') { Write-Output $imageState.ImageState; Start-Sleep -s 10  } else { break } }"
            ]
        }
    ]
}
