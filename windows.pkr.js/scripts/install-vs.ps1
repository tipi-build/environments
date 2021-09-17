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
	"--allWorkloads --includeRecommended"
	"--add Component.Dotfuscator",
	"--add Component.Linux.CMake"
	"--add Component.UnityEngine.x64"
	"--add Component.Unreal.Android"
	"--add Microsoft.Component.Azure.DataLake.Tools"
	"--add Microsoft.Component.PythonTools.Miniconda"
	"--add Microsoft.Component.PythonTools.Web"
	"--add Microsoft.Component.VC.Runtime.UCRTSDK"
	"--add Microsoft.Net.ComponentGroup.4.6.2.DeveloperTools"
	"--add Microsoft.Net.ComponentGroup.4.7.1.DeveloperTools"
	"--add Microsoft.Net.Component.4.7.2.SDK"
	"--add Microsoft.Net.Component.4.7.2.TargetingPack"
	"--add Microsoft.Net.ComponentGroup.4.7.DeveloperTools"
	"--add Microsoft.VisualStudio.Component.AspNet45"
	"--add Microsoft.VisualStudio.Component.Azure.Kubernetes.Tools"
	"--add Microsoft.VisualStudio.Component.Azure.ServiceFabric.Tools"
	"--add Microsoft.VisualStudio.Component.Azure.Storage.AzCopy"
	"--add Microsoft.VisualStudio.Component.Debugger.JustInTime"
	"--add Microsoft.VisualStudio.Component.DslTools"
	"--add Microsoft.VisualStudio.Component.EntityFramework"
	"--add Microsoft.VisualStudio.Component.FSharp.Desktop"
	"--add Microsoft.VisualStudio.Component.LinqToSql"
	"--add Microsoft.VisualStudio.Component.SQL.SSDT"
	"--add Microsoft.VisualStudio.Component.Sharepoint.Tools"
	"--add Microsoft.VisualStudio.Component.PortableLibrary"
	"--add Microsoft.VisualStudio.Component.TeamOffice"
	"--add Microsoft.VisualStudio.Component.TestTools.CodedUITest"
	"--add Microsoft.VisualStudio.Component.TestTools.WebLoadTest"
	"--add Microsoft.VisualStudio.Component.UWP.VC.ARM64"
	"--add Microsoft.VisualStudio.Component.VC.140"
	"--add Microsoft.VisualStudio.Component.VC.ATL.ARM"
	"--add Microsoft.VisualStudio.Component.VC.ATLMFC"
	"--add Microsoft.VisualStudio.Component.VC.ATLMFC.Spectre"
	"--add Microsoft.VisualStudio.Component.VC.CLI.Support"
	"--add Microsoft.VisualStudio.Component.VC.CMake.Project"
	"--add Microsoft.VisualStudio.Component.VC.DiagnosticTools"
	"--add Microsoft.VisualStudio.Component.VC.Llvm.ClangToolset"
	"--add Microsoft.VisualStudio.Component.VC.MFC.ARM"
	"--add Microsoft.VisualStudio.Component.VC.MFC.ARM.Spectre"
	"--add Microsoft.VisualStudio.Component.VC.MFC.ARM64"
	"--add Microsoft.VisualStudio.Component.VC.MFC.ARM64.Spectre"
	"--add Microsoft.VisualStudio.Component.VC.Redist.MSM"
	"--add Microsoft.VisualStudio.Component.VC.Runtimes.ARM.Spectre"
	"--add Microsoft.VisualStudio.Component.VC.Runtimes.ARM64.Spectre"
	"--add Microsoft.VisualStudio.Component.VC.Runtimes.x86.x64.Spectre"
	"--add Microsoft.VisualStudio.Component.VC.TestAdapterForBoostTest"
	"--add Microsoft.VisualStudio.Component.VC.TestAdapterForGoogleTest"
	"--add Microsoft.VisualStudio.Component.VC.v141.x86.x64"
	"--add Microsoft.VisualStudio.Component.VC.v141.x86.x64.Spectre"
	"--add Microsoft.VisualStudio.Component.VC.v141.ARM.Spectre"
	"--add Microsoft.VisualStudio.Component.VC.v141.ARM64.Spectre"
	"--add Microsoft.VisualStudio.Component.VC.v141.ATL"
	"--add Microsoft.VisualStudio.Component.VC.v141.ATL.ARM.Spectre"
	"--add Microsoft.VisualStudio.Component.VC.v141.ATL.ARM64.Spectre"
	"--add Microsoft.VisualStudio.Component.VC.v141.ATL.Spectre"
	"--add Microsoft.VisualStudio.Component.VC.v141.MFC"
	"--add Microsoft.VisualStudio.Component.VC.v141.MFC.ARM.Spectre"
	"--add Microsoft.VisualStudio.Component.VC.v141.MFC.ARM64.Spectre"
	"--add Microsoft.VisualStudio.Component.VC.v141.MFC.Spectre"
	"--add Microsoft.VisualStudio.Component.VC.14.25.x86.x64"
	"--add Microsoft.VisualStudio.Component.Windows10SDK.16299"
	"--add Microsoft.VisualStudio.Component.Windows10SDK.17134"
	"--add Microsoft.VisualStudio.Component.Windows10SDK.17763"
	"--add Microsoft.VisualStudio.Component.Windows10SDK.18362"
	"--add Microsoft.VisualStudio.Component.Windows10SDK.19041"
	"--add Microsoft.VisualStudio.Component.WinXP"
	"--add Microsoft.VisualStudio.Component.Workflow"
	"--add Microsoft.VisualStudio.ComponentGroup.Azure.CloudServices"
	"--add Microsoft.VisualStudio.ComponentGroup.Azure.ResourceManager.Tools"
	"--add Microsoft.VisualStudio.ComponentGroup.NativeDesktop.Llvm.Clang"
	"--add Microsoft.VisualStudio.ComponentGroup.Web.CloudTools"
	"--add Microsoft.VisualStudio.ComponentGroup.UWP.VC"
	"--add Microsoft.VisualStudio.Workload.Azure"
	"--add Microsoft.VisualStudio.Workload.Data"
	"--add Microsoft.VisualStudio.Workload.DataScience"
	"--add Microsoft.VisualStudio.Workload.ManagedDesktop"
	"--add Microsoft.VisualStudio.Workload.ManagedGame"
	"--add Microsoft.VisualStudio.Workload.NativeCrossPlat"
	"--add Microsoft.VisualStudio.Workload.NativeDesktop"
	"--add Microsoft.VisualStudio.Workload.NativeGame"
	"--add Microsoft.VisualStudio.Workload.NativeMobile"
	"--add Microsoft.VisualStudio.Workload.NetCoreTools"
	"--add Microsoft.VisualStudio.Workload.NetCrossPlat"
	"--add Microsoft.VisualStudio.Workload.NetWeb"
	"--add Microsoft.VisualStudio.Workload.Node"
	"--add Microsoft.VisualStudio.Workload.Office"
	"--add Microsoft.VisualStudio.Workload.Python"
	"--add Microsoft.VisualStudio.Workload.Universal"
	"--add Microsoft.VisualStudio.Workload.VisualStudioExtension"
	"--add Component.MDD.Linux"
	"--add Component.MDD.Linux.GCC.arm"
	"--remove Component.CPython3.x64"
)
$workLoadsArgument = [String]::Join(" ", $workLoads)
		
$releaseInPath = "Enterprise"
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