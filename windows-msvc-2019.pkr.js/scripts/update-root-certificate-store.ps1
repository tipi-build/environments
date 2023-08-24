Set-StrictMode -Version latest
$ErrorActionPreference = "Stop"

$RunningAsAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
if (!$RunningAsAdmin) {
  Write-Error "Must be executed in Administrator clevel shell."
  exit 1
}

# Force TLS1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Try {
    
    #$storeFile = "c:\Temp\roots.sst"
    #md c:\Temp
    #certutil.exe -generateSSTFromWU $storeFile
    #$sst = ( Get-ChildItem -Path $storeFile )
    #$sst | Import-Certificate -CertStoreLocation Cert:\LocalMachine\Root
    #updroots.exe roots.sst

    Write-Output "Preparing fetching root CA info from Windows Update"

    $certsPath = "c:\Temp\certs"
    $rootCertsPath = "c:\Temp\certs\root.sst"
    md $certsPath

    Write-Output "Fetching now..."
    #certutil -syncwithWU $certsPath
    certutil.exe -generateSSTFromWU $rootCertsPath
    
    Write-Output "Importing certificate updates into machine root store"
    $sst = ( Get-ChildItem -Path $rootCertsPath )
    $sst | Import-Certificate -CertStoreLocation Cert:\LocalMachine\Root
    #$files = Get-ChildItem -Path 'C:\certs\*' -Include '*.crt'
    
    #Foreach ($file in $files) {
    #    $importfile = "$file"
    #    certutil -addstore -f Root "$importfile"
    #    Write-Output $importfile
    #}
    
    Write-Output "Cleaning up disk"
    rd $certsPath -Recurse

} Catch {
    Write-Error "Failed to update the root certificate store"
    $host.SetShouldExit(-1)
    throw
}

Write-Output "Updated the root certificate store from Windows update"