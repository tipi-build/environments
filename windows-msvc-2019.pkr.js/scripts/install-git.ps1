################################################################################
##  File:  Install-Git.ps1
##  Desc:  Install Git for Windows
################################################################################

# source the helpers
. ("c:\temp\helpers.ps1")

# Force TLS1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

function getSimpleValue([string] $url, [string] $filename ) {
    $fullpath = "${env:Temp}\$filename"
    Invoke-WebRequest -Uri $url -OutFile $fullpath
    $value = Get-Content $fullpath -Raw

    return $value
}

# Install the latest version of Git for Windows
#$gitTag = getSimpleValue -url "https://gitforwindows.org/latest-tag.txt" -filename "gitlatesttag.txt"
#$gitVersion = getSimpleValue -url "https://gitforwindows.org/latest-version.txt" -filename "gitlatestversion.txt";

# there's an installer bug in the current latest, manually sticking the the previous release for now
$gitTag = "v2.32.0.windows.2"
$gitVersion = "2.32.0.2"


$installerFile = "Git-$gitVersion-64-bit.exe";
$downloadUrl = "https://github.com/git-for-windows/git/releases/download/$gitTag/$installerFile";
Install-Binary  -Url $downloadUrl `
                -Name $installerFile `
                -ArgumentList (
                    "/VERYSILENT",
                    "/NORESTART", `
                    "/NOCANCEL", `
                    "/SP-", `
                    "/CLOSEAPPLICATIONS", `
                    "/RESTARTAPPLICATIONS", `
                    "/o:PathOption=CmdTools", `
                    "/o:BashTerminalOption=ConHost", `
                    "/o:EnableSymlinks=Enabled", `
                    "/COMPONENTS=gitlfs")

# Disable GCM machine-wide
[Environment]::SetEnvironmentVariable("GCM_INTERACTIVE", "Never", [System.EnvironmentVariableTarget]::Machine)

# add git bin dir to machine path
$context = [EnvironmentVariableTarget]::Machine
$PATH_orig = [Environment]::GetEnvironmentVariable("Path", $context)

$PATH_new = "C:\Program Files\Git\bin;" + $PATH_orig    # prepending so the latest install wins the path race
$PATH_new = $PATH_new -replace ';{2,}',';'              # clean the path of eventual double ;; entries
[Environment]::SetEnvironmentVariable("Path", $PATH_new, $context)

# Add well-known SSH host keys to ssh_known_hosts
ssh-keyscan -t rsa github.com >> "C:\Program Files\Git\etc\ssh\ssh_known_hosts"
ssh-keyscan -t rsa ssh.dev.azure.com >> "C:\Program Files\Git\etc\ssh\ssh_known_hosts"