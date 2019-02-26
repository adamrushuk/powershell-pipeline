$ProjectRoot = $ENV:BHProjectPath
if (-not $ProjectRoot) {
    $ProjectRoot = $PSScriptRoot
}

$Timestamp = Get-Date -UFormat '%Y%m%d-%H%M%S'
$PSVersion = $PSVersionTable.PSVersion.Major
$lines = '----------------------------------------------------------------------'

# Pester
$TestScripts = Get-ChildItem "$ProjectRoot\Tests\*\*Tests.ps1"
$TestFile = "Test-Unit_$($TimeStamp).xml"

# Script Analyzer
[ValidateSet('Error', 'Warning', 'Any', 'None')]
$ScriptAnalysisFailBuildOnSeverityLevel = 'Error'
$ScriptAnalyzerSettingsPath = "$ProjectRoot\PSScriptAnalyzerSettings.psd1"

# Build
$ArtifactFolder = Join-Path -Path $ProjectRoot -ChildPath 'Artifacts'

# Staging
$StagingFolder = Join-Path -Path $projectRoot -ChildPath 'Staging'
$StagingModulePath = Join-Path -Path $StagingFolder -ChildPath $env:BHProjectName
$StagingModuleManifestPath = Join-Path -Path $StagingModulePath -ChildPath "$($env:BHProjectName).psd1"

# Documentation
$DocumentationPath = Join-Path -Path $StagingFolder -ChildPath 'Documentation'

$lines

# Create /Release folder
New-Item -Path $ArtifactFolder -ItemType 'Directory' -Force | Out-String | Write-Verbose

# Get current manifest version
try {
    $manifest = Test-ModuleManifest -Path $StagingModuleManifestPath -ErrorAction 'Stop'
    [Version]$manifestVersion = $manifest.Version

} catch {
    throw "Could not get manifest version from [$StagingModuleManifestPath]"
}

# Create zip file
try {
    $releaseFilename = "$env:BHProjectName-v$($manifestVersion.ToString()).zip"
    $releasePath = Join-Path -Path $ArtifactFolder -ChildPath $releaseFilename
    Write-Host "Creating release artifact [$releasePath] using manifest version [$manifestVersion]" -ForegroundColor 'Yellow'
    Compress-Archive -Path "$StagingFolder/*" -DestinationPath $releasePath -Force -Verbose -ErrorAction 'Stop'
} catch {
    throw "Could not create release artifact [$releasePath] using manifest version [$manifestVersion]"
}

Write-Output "`nFINISHED: Release artifact creation."
