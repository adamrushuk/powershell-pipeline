[CmdletBinding()]
param (
    [Parameter()]
    [System.String[]]
    $TaskList = 'Default',

    [Parameter()]
    [System.Collections.Hashtable]
    $Parameters,

    [Parameter()]
    [System.Collections.Hashtable]
    $Properties
)

Write-Output "`nSTARTED TASKS: $($TaskList -join ',')`n"

Write-Output "`nPowerShell Version Information:"
$PSVersionTable

# Bootstrap environment
Get-PackageProvider -Name 'NuGet' -ForceBootstrap | Out-Null

# Install PSDepend module if it is not already installed
if (-not (Get-Module -Name 'PSDepend' -ListAvailable)) {
    Write-Output "`nPSDepend is not yet installed...installing PSDepend now..."
    Install-Module -Name 'PSDepend' -Scope 'CurrentUser' -Force
} else {
    Write-Output "`nPSDepend already installed...skipping."
}

# Install build dependencies
Import-Module -Name 'PSDepend'
$invokePSDependParams = @{
    Path    = (Join-Path -Path $PSScriptRoot -ChildPath 'psvcloud.depend.psd1')
    # Tags = 'Bootstrap'
    Import  = $true
    Confirm = $false
    Install = $true
    # Verbose = $true
}
Invoke-PSDepend @invokePSDependParams

# Init BuildHelpers
Set-BuildEnvironment -Force

# Import module
Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force

# Execute PSake tasts
$invokePsakeParams = @{
    buildFile = (Join-Path -Path $env:BHProjectPath -ChildPath 'Build\build.psake.ps1')
    nologo    = $true
}
Invoke-Psake @invokePsakeParams @PSBoundParameters

Write-Output "`nFINISHED TASKS: $($TaskList -join ',')"
exit ( [int](-not $psake.build_success) )
