Set-StrictMode -Version latest
$ErrorActionPreference = "Stop"

$RunningAsAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
if (!$RunningAsAdmin) {
  Write-Error "Must be executed in Administrator level shell."
  exit 1
}

Try {
    # we do LOTs of file access... windows defender is a HUGE break
    # in that regard... disabling it for good measure 
    # 
    # benchmarked: 
    # -50% file copy time when copying the distro from c:/ to d:/ 
    # with disabling defender alone.
    Set-MpPreference -DisableRealtimeMonitoring $true    
    
} Catch {
    Write-Error "Failed to disable windows defender"
    $host.SetShouldExit(-1)
    throw
}

Write-Output "Disabled Windows Defender Realtime Threat Protection"