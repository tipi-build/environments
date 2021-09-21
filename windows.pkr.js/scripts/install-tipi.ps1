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
    # the *temporary* storage is not persisted between provisioning
    # and runtime, hence we want to copy over to the final location POST-boot
    $provisioningTimeTarget = "C:\.tipi"
    $runtimeTimeTarget = "D:\.tipi"

    Write-Output "Installing tipi in: "
    Write-Output $provisioningTimeTarget

    # set the TIPI_HOME_DIR during privisioning
    $env:TIPI_HOME_DIR = $provisioningTimeTarget

    # have the target folder created and read/writable for everyone
    md $provisioningTimeTarget
    icacls $provisioningTimeTarget /grant Users:F

    # install tipi
    . { iwr -useb https://raw.githubusercontent.com/tipi-build/cli/feature/verbose-install/install/install_for_windows.ps1 } | iex

    # set the TIPI_HOME_DIR to our runtime target directory and setup file-sync
    [System.Environment]::SetEnvironmentVariable('TIPI_HOME_DIR', $runtimeTimeTarget, [System.EnvironmentVariableTarget]::Machine)

    # schedule a job to sync stuff between the c: and d: drive after startup
    $taskTrigger = New-ScheduledTaskTrigger -AtStartup
    $taskUser = "NT AUTHORITY\SYSTEM"
    $taskAction = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-file c:\Temp\sync-tipi-distro.ps1"
    $taskPriority = 1 # 0: "realtime" / 1: highest prio ... 9: lowest    
    $taskSettings = New-ScheduledTaskSettingsSet -Priority $taskPriority
    Register-ScheduledTask -TaskName "tipi-distro-sync" -Trigger $taskTrigger -User $taskUser -Action $taskAction -Settings $taskSettings -RunLevel Highest -Force

    #schtasks /create /tn " /sc onstart /delay 0000:10 /rl highest /ru system /tr "powershell.exe -file c:\Temp\sync-tipi-distro.ps1"

} Catch {
    Write-Error "Failed to install tipicli :'("
    $host.SetShouldExit(-1)
    throw
}

Write-Output "Installed tipicli."