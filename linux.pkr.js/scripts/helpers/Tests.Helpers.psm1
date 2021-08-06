Import-Module "$PSScriptRoot/../helpers/Common.Helpers.psm1" -DisableNameChecking

# Validates that tool is installed and in PATH
function Validate-ToolExist($tool) {
    Get-Command $tool -ErrorAction SilentlyContinue | Should -BeTrue
}

function Invoke-PesterTests {
    Param(
        [Parameter(Mandatory)][string] $TestFile,
        [string] $TestName
    )

    $testPath = "/imagegeneration/tests/${TestFile}.Tests.ps1"
    if (-not (Test-Path $testPath)) {
        throw "Unable to find test file '$TestFile' on '$testPath'."
    }

    $configuration = [PesterConfiguration] @{
        Run = @{ Path = $testPath; PassThru = $true }
        Output = @{ Verbosity = "Detailed" }
    }
    if ($TestName) {
        $configuration.Filter.FullName = $TestName
    }

    # Switch ErrorActionPreference to Stop temporary to make sure that tests will fail on silent errors too
    $backupErrorActionPreference = $ErrorActionPreference
    $ErrorActionPreference = "Stop"
    $results = Invoke-Pester -Configuration $configuration
    $ErrorActionPreference = $backupErrorActionPreference

    # Fail in case if no tests are run
    if (-not ($results -and ($results.FailedCount -eq 0) -and ($results.PassedCount -gt 0))) {
        $results
        throw "Test run has failed"
    }
}

function ShouldReturnZeroExitCode {
    Param(
        [String] $ActualValue,
        [switch] $Negate,
        [string] $Because # This parameter is unused but we need it to match Pester asserts signature
    )

    $result = Get-CommandResult $ActualValue

    [bool]$succeeded = $result.ExitCode -eq 0
    if ($Negate) { $succeeded = -not $succeeded }

    if (-not $succeeded)
    {
        $commandOutputIndent = " " * 4
        $commandOutput = ($result.Output | ForEach-Object { "${commandOutputIndent}${_}" }) -join "`n"
        $failureMessage = "Command '${ActualValue}' has finished with exit code`n${commandOutput}"
    }

    return [PSCustomObject] @{
        Succeeded      = $succeeded
        FailureMessage = $failureMessage
    }
}

If (Get-Command -Name Add-AssertionOperator -ErrorAction SilentlyContinue) {
    Add-AssertionOperator -Name ReturnZeroExitCode -InternalName ShouldReturnZeroExitCode -Test ${function:ShouldReturnZeroExitCode}
}