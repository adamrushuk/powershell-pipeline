param ($Task = 'Default')

$global:VerbosePreference = "SilentlyContinue"

# Grab nuget bits, install modules, set build variables, start build.
Get-PackageProvider -Name 'NuGet' -ForceBootstrap | Out-Null

# Install modules if required
$ModNames = @('Psake', 'PSDeploy', 'BuildHelpers', 'PSScriptAnalyzer', 'VMware.VimAutomation.Cloud')
foreach ($ModName in $ModNames) {
    if (-not (Get-Module -Name $ModName -ListAvailable)) {
        Write-Verbose "$ModName module not installed. Installing from PSGallery..."
        Install-Module -Name $ModName -Force -AllowClobber -Scope 'CurrentUser' > $null
    }

    if (-not (Get-Module -Name $ModName)) {
        Import-Module -Name $ModName -Force
    }
}

# Target latest version of Pester as older versions are bundled with OS
if (-not (Get-Module -Name 'Pester' -ListAvailable | Where-Object {$_.Version -match '^4.'})) {
    Install-Module 'Pester' -MinimumVersion '4.4.2' -Force -AllowClobber -Scope 'CurrentUser' -SkipPublisherCheck -ErrorAction 'Stop'
}
if (-not (Get-Module -Name 'Pester')) {
    Import-Module -Name 'Pester' -Force
}

Set-BuildEnvironment

Invoke-psake -buildFile $ENV:BHProjectPath\Build\build.psake.ps1 -taskList $Task -nologo
exit ( [int]( -not $psake.build_success ) )
