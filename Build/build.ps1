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

# Bootstrap environment
Get-PackageProvider -Name 'NuGet' -ForceBootstrap | Out-Null

# Install PSDepend module if it is not already installed
if (-not (Get-Module -Name 'PSDepend' -ListAvailable)) {
    Install-Module -Name 'PSDepend' -Scope 'CurrentUser' -Force -Confirm:$false
}

# Install build dependencies
Import-Module -Name 'PSDepend'
$invokePSDependParams = @{
    Path    = (Join-Path -Path $PSScriptRoot -ChildPath 'psvcloud.depend.psd1')
    # Tags = 'Bootstrap'
    Import  = $true
    Force   = $true
    Install = $true
}
Invoke-PSDepend @invokePSDependParams

# Init BuildHelpers
Set-BuildEnvironment -Force

# Execute PSake tasts
$invokePsakeParams = @{
    buildFile = (Join-Path -Path $ENV:BHProjectPath -ChildPath 'Build\build.psake.ps1')
    nologo    = $true
}
Invoke-Psake @invokePsakeParams @PSBoundParameters

Write-Output "`nFINISHED TASKS: $($TaskList -join ',')"
exit ( [int]( -not $psake.build_success ) )
