[CmdletBinding()]
param (
    [string]$PAT,
    [string]$SecretVar
)

# Variables
# $powershellGetVersion = '1.5.0.0' # DO NOT use the latest 1.6.0 version as there is issues with this process
# $moduleFolderPath = 'C:\Users\adamr\code\PowerShellPipeline\Staging\PSvCloud' # only target folder, NOT the .psm1 or .psd1
$moduleFolderPath = Join-Path -Path $env:SYSTEM_ARTIFACTSDIRECTORY -ChildPath "PowerShellPipeline\PSModule\PSvCloud"
$repositoryName = 'psmodules'
$feedUsername = 'NotChecked'
$packageSourceUrl = "https://adamrushuk.pkgs.visualstudio.com/_packaging/$repositoryName/nuget/v2" # Enter your VSTS AccountName (note: v2 Feed)

# Testing
Write-Host "ARTestVar env var: [$env:ARTestVar]"
Write-Host "ArtifactFeedPat env var: [$env:ArtifactFeedPat]"
Write-Host "PAT param passed in: [$PAT]"
Write-Host "SecretVar param passed in: [$SecretVar]"
<#
Write-Host "NuGet binary info:"
Get-Command NuGet.exe | Format-List *

Get-ChildItem $moduleFolderPath
Test-ModuleManifest -Path "$moduleFolderPath\PSvCloud.psd1"
#>

# This is downloaded during Step 3, but could also be "C:\Users\USERNAME\AppData\Local\Microsoft\Windows\PowerShell\PowerShellGet\NuGet.exe"
# if not running script as Administrator.
$nugetPath = (Get-Command NuGet.exe).Source
if (-not (Test-Path -Path $nugetPath)) {
    # $nugetPath = 'C:\ProgramData\Microsoft\Windows\PowerShell\PowerShellGet\NuGet.exe'
    $nugetPath = Join-Path -Path $env:LOCALAPPDATA -ChildPath 'Microsoft\Windows\PowerShell\PowerShellGet\NuGet.exe'
}

# Create credential
$password = ConvertTo-SecureString -String $PAT -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ($feedUsername, $password)


# Step 1
# Upgrade PowerShellGet
# Install-Module PowerShellGet -RequiredVersion $powershellGetVersion -Force
# Remove-Module PowerShellGet -Force
# Import-Module PowerShellGet -RequiredVersion $powershellGetVersion -Force


# Step 2
# Check NuGet is listed
Get-PackageProvider -Name 'NuGet' -ForceBootstrap | Format-List *


# Step 3
# THIS WILL FAIL first time, so don't panic!
# Try to Publish a PowerShell module - this will prompt and download NuGet.exe, and fail publishing the module (we publish at the end)
$publishParams = @{
    Path        = $moduleFolderPath
    Repository  = $repositoryName
    NugetApiKey = 'VSTS'
    Force       = $true
    Verbose     = $true
    ErrorAction = 'SilentlyContinue'
}
Publish-Module @publishParams


# Step 4
# Register NuGet Package Source
& $nugetPath Sources Add -Name $repositoryName -Source $packageSourceUrl -Username $feedUsername -Password $PAT

# Check new NuGet Source is registered
& $nugetPath Sources List


# Step 5
# Register feed
$registerParams = @{
    Name                      = $repositoryName
    SourceLocation            = $packageSourceUrl
    PublishLocation           = $packageSourceUrl
    InstallationPolicy        = 'Trusted'
    PackageManagementProvider = 'Nuget'
    Credential                = $credential
    Verbose                   = $true
}
Register-PSRepository @registerParams

# Check new PowerShell Repository is registered
Get-PSRepository -Name $repositoryName


# Step 6
# Publish PowerShell module (2nd time lucky!)
Publish-Module @publishParams
