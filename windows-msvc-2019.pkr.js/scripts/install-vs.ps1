################################################################################
##  File:  Install-VS.ps1
##  Desc:  Install Visual Studio
################################################################################

# source the helpers
. ("c:\temp\helpers.ps1")

# Force TLS1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Function Install-VisualStudio
{
    <#
    .SYNOPSIS
        A helper function to install Visual Studio.

    .DESCRIPTION
        Prepare system environment, and install Visual Studio bootstrapper with selected workloads.

    .PARAMETER BootstrapperUrl
        The URL from which the bootstrapper will be downloaded. Required parameter.

    .PARAMETER WorkLoads
        The string that contain workloads that will be passed to the installer.
    #>

    Param
    (
        [Parameter(Mandatory)]
        [String] $BootstrapperUrl,
        [String] $WorkLoads
    )

    Write-Host "Downloading Bootstrapper ..."
    $BootstrapperName = [IO.Path]::GetFileName($BootstrapperUrl)
    $bootstrapperFilePath = Start-DownloadWithRetry -Url $BootstrapperUrl -Name $BootstrapperName

    try
    {
        Write-Host "Enable short name support on Windows needed for Xamarin Android AOT, defaults appear to have been changed in Azure VMs"
        $shortNameEnableProcess = Start-Process -FilePath fsutil.exe -ArgumentList ('8dot3name', 'set', '0') -Wait -PassThru

        $shortNameEnableExitCode = $shortNameEnableProcess.ExitCode
        if ($shortNameEnableExitCode -ne 0)
        {
            Write-Host "Enabling short name support on Windows failed. This needs to be enabled prior to VS 2017 install for Xamarin Andriod AOT to work."
            exit $shortNameEnableExitCode
        }

        Write-Host "Starting Install ..."
        $bootstrapperArgumentList = ('/c', $bootstrapperFilePath, $WorkLoads, '--quiet', '--norestart', '--wait', '--nocache' )
        $process = Start-Process -FilePath cmd.exe -ArgumentList $bootstrapperArgumentList -Wait -PassThru

        $exitCode = $process.ExitCode
        if ($exitCode -eq 0 -or $exitCode -eq 3010)
        {
            Write-Host "Installation successful"
            return $exitCode
        }
        else
        {
            $setupErrorLogPath = "$env:TEMP\dd_setup_*_errors.log"
            if (Test-Path -Path $setupErrorLogPath)
            {
                $logErrors = Get-Content -Path $setupErrorLogPath -Raw
                Write-Host "$logErrors"
            }

            Write-Host "Non zero exit code returned by the installation process : $exitCode"
            exit $exitCode
        }
    }
    catch
    {
        Write-Host "Failed to install Visual Studio; $($_.Exception.Message)"
        exit -1
    }
}

function Get-VsCatalogJsonPath {
    $instanceFolder = Get-Item "C:\ProgramData\Microsoft\VisualStudio\Packages\_Instances\*" | Select-Object -First 1
    return Join-Path $instanceFolder.FullName "catalog.json"
}

function Get-VisualStudioPath {
    return (Get-VSSetupInstance | Select-VSSetupInstance -Product *).InstallationPath
}

function Get-VisualStudioPackages {
    return (Get-VSSetupInstance | Select-VSSetupInstance -Product *).Packages
}

function Get-VisualStudioComponents {
    Get-VisualStudioPackages | Where-Object type -in 'Component', 'Workload' |
    Sort-Object Id, Version | Select-Object @{n = 'Package'; e = {$_.Id}}, Version |
    Where-Object { $_.Package -notmatch "[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}" }
}

$workLoads = @(
    "--add Microsoft.VisualStudio.Workload.VCTools"
    "--add Microsoft.VisualStudio.Workload.NativeDesktop"
	"--includeOptional"
	"--includeRecommended"
	"--remove Component.CPython3.x64"
)
$workLoadsArgument = [String]::Join(" ", $workLoads)
		
$releaseInPath = "BuildTools"
$subVersion =  "16"
$bootstrapperUrl = "https://aka.ms/vs/${subVersion}/release/vs_${releaseInPath}.exe"

# Install VS
Install-VisualStudio -BootstrapperUrl $bootstrapperUrl -WorkLoads $workLoadsArgument

# Find the version of VS installed for this instance
# Only supports a single instance
$vsProgramData = Get-Item -Path "C:\ProgramData\Microsoft\VisualStudio\Packages\_Instances"
$instanceFolders = Get-ChildItem -Path $vsProgramData.FullName

if ($instanceFolders -is [array])
{
    Write-Host "More than one instance installed"
    exit 1
}

$vsInstallRoot = Get-VisualStudioPath

# Initialize Visual Studio Experimental Instance
& "$vsInstallRoot\Common7\IDE\devenv.exe" /RootSuffix Exp /ResetSettings General.vssettings /Command File.Exit

# Updating content of MachineState.json file to disable autoupdate of VSIX extensions
$newContent = '{"Extensions":[{"Key":"1e906ff5-9da8-4091-a299-5c253c55fdc9","Value":{"ShouldAutoUpdate":false}},{"Key":"Microsoft.VisualStudio.Web.AzureFunctions","Value":{"ShouldAutoUpdate":false}}],"ShouldAutoUpdate":false,"ShouldCheckForUpdates":false}'
Set-Content -Path "$vsInstallRoot\Common7\IDE\Extensions\MachineState.json" -Value $newContent