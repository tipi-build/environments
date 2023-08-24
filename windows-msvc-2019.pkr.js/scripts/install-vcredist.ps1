Set-StrictMode -Version latest
$ErrorActionPreference = "Stop"

$RunningAsAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
if (!$RunningAsAdmin) {
  Write-Error "Must be executed in Administrator level shell."
  exit 1
}

# Force TLS1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Try {

    $tmpPath = "C:\Temp\VcRedist"
    New-Item -ItemType Directory -Force -Path $tmpPath

    Install-Module -Name VcRedist -Force -Confirm:$False
    $redistList = Get-VcList | Get-VcRedist -Path $tmpPath    
    
    Install-VcRedist -Path $tmpPath -VcList $redistList -Silent

    Remove-Item -Recurse -Force $tmpPath

} Catch {
    Write-Error "Failed to install vc redist runtimes."
    $host.SetShouldExit(-1)
    throw
}

Write-Output "Installed VcRedist."