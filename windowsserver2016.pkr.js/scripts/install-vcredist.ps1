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
    Install-Module -Name VcRedist -Force -Confirm:$False
    md C:\Temp\VcRedist
    
    Save-VcRedist -VcList (Get-VcList -Release 2010, 2013, 2019) -Path C:\Temp\VcRedist
    Install-VcRedist -Path C:\Temp\VcRedist -VcList (Get-VcList) -Silent
} Catch {
    Write-Error "Failed to install vc redist runtimes."
    $host.SetShouldExit(-1)
    throw
}

Write-Output "Installed VcRedist."