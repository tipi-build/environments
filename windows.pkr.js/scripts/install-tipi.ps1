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
  # force distro mode all so we have all the requisite tools preinstalled
  $env:TIPI_DISTRO_MODE = "all"
  Write-Output "Installing tipi in distro mode '$env:TIPI_DISTRO_MODE'"

  # do a system install because otherwise it's the image-creation user who'll get tipi 
  # installe in his user profile & PATH... which will be deleted on imaging completion
  # which would result in the tipi.build customer not having a working installation
  $env:TIPI_INSTALL_SYSTEM = "True"
  Write-Output "Installing tipi in system install mode: $env:TIPI_INSTALL_SYSTEM"

  # have the target folder created and read/writable for everyone
  $provisioningTimeTarget = "C:\.tipi"
  mkdir $provisioningTimeTarget
  icacls $provisioningTimeTarget /grant Users:F

  # we need that for a few more days I guess
  $env:TIPI_HOME_DIR = $provisioningTimeTarget

  # install tipi
  . { Invoke-WebRequest -useb https://raw.githubusercontent.com/tipi-build/cli/master/install/install_for_windows.ps1 } | Invoke-Expression

  try {
    # clean up the download folder to have less clutter / smaller images
    Get-ChildItem "$provisioningTimeTarget\downloads\*" -Recurse -Force `
    | Sort-Object -Property FullName -Descending `
    | ForEach-Object {
      Remove-Item -Path $_.FullName -Force -ErrorAction Stop;
    }
  }
  catch {
    Write-Host " XXX Failed to clean download folder"
    Write-Host ($_ | ConvertTo-Json)  -ErrorAction Continue
  }

} Catch {
  Write-Error "Failed to install tipicli :'(" -ErrorAction Continue
  Write-Error ($_ | ConvertTo-Json) -ErrorAction Continue
  $host.SetShouldExit(-1)
  throw
}

Write-Output "Installed tipicli."
