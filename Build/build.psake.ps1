# PSake makes variables declared here available in other scriptblocks
Properties {
    $ProjectRoot = $ENV:BHProjectPath
    if (-not $ProjectRoot) {
        $ProjectRoot = $PSScriptRoot
    }

    $Timestamp = Get-Date -UFormat '%Y%m%d-%H%M%S'
    $PSVersion = $PSVersionTable.PSVersion.Major
    $lines = '----------------------------------------------------------------------'

    # Pester
    $TestScripts = Get-ChildItem "$ProjectRoot\Tests\*\*Tests.ps1"
    $TestFile = "$($TimeStamp)_UnitTestResults.xml"

    # Script Analyzer
    [ValidateSet('Error', 'Warning', 'Any', 'None')]
    $ScriptAnalysisFailBuildOnSeverityLevel = 'None'
    $ScriptAnalyzerSettingsPath = "$ProjectRoot\PSScriptAnalyzerSettings.psd1"

    # Documentation
    $DocumentationPath = Join-Path -Path $ProjectRoot -ChildPath 'Documentation'

    # Build
    $ArtifactFolder = Join-Path -Path $ProjectRoot -ChildPath 'Artifacts'

    # Staging
    $StagingFolder = Join-Path -Path $projectRoot -ChildPath 'Staging'
    $StagingModulePath = Join-Path -Path $StagingFolder -ChildPath $env:BHProjectName
}


# Define top-level tasks
Task 'Default' -Depends 'Test'
Task 'Release' -Depends 'Clean', 'Test', 'UpdateDocumentation', 'CombineFunctionsAndStage', 'CreateReleaseArtifact' #'UpdateManifest', 'UpdateTag',


# Main tasks
Task 'Init' {
    $lines
    Set-Location $ProjectRoot
    "Build System Details:"
    Get-Item ENV:BH*
    "`n"
}


Task 'Analyze' -Depends 'Init' {

    $Results = Invoke-ScriptAnalyzer -Path $ENV:BHModulePath -Recurse -Settings $ScriptAnalyzerSettingsPath -Verbose:$VerbosePreference
    $Results | Select-Object 'RuleName', 'Severity', 'ScriptName', 'Line', 'Message' | Format-List

    switch ($ScriptAnalysisFailBuildOnSeverityLevel) {

        'None' {
            return
        }
        'Error' {
            Assert -conditionToCheck (
                ($Results | Where-Object 'Severity' -eq 'Error').Count -eq 0
            ) -failureMessage 'One or more ScriptAnalyzer errors were found. Build cannot continue!'
        }
        'Warning' {
            Assert -conditionToCheck (
                ($Results | Where-Object {
                        $_.Severity -eq 'Warning' -or $_.Severity -eq 'Error'
                    }).Count -eq 0) -failureMessage 'One or more ScriptAnalyzer warnings were found. Build cannot continue!'
        }
        default {
            Assert -conditionToCheck ($analysisResult.Count -eq 0) -failureMessage 'One or more ScriptAnalyzer issues were found. Build cannot continue!'
        }

    }

}


Task 'Test' -Depends 'Analyze' {
    $lines
    "`nSTATUS: Testing with PowerShell $PSVersion"

    # Gather test results. Store them in a variable and file
    $TestFilePath = Join-Path -Path $ArtifactFolder -ChildPath $TestFile
    $TestResults = Invoke-Pester -Script $TestScripts -PassThru -OutputFormat 'NUnitXml' -OutputFile $TestFilePath -PesterOption @{IncludeVSCodeMarker = $true}

    # Upload test results to Appveyor
    if ($ENV:BHBuildSystem -eq 'AppVeyor') {
        Add-TestResultToAppVeyor -TestFile $TestFilePath
    }

    # Remove-Item $TestFilePath -Force -ErrorAction 'SilentlyContinue'

    # Fail build if any tests fail
    if ($TestResults.FailedCount -gt 0) {
        Write-Error "Failed '$($TestResults.FailedCount)' tests, build failed"
    }
    "`n"
}


Task 'Build' -Depends 'Test' {
    $lines

    # Load the module, read the exported functions, update the psd1 FunctionsToExport
    Set-ModuleFunctions -Name $env:BHPSModuleManifest

    # Bump the module version
    try {
        $Version = Get-NextPSGalleryVersion -Name $env:BHProjectName -ErrorAction 'Stop'
        Update-Metadata -Path $env:BHPSModuleManifest -PropertyName 'ModuleVersion' -Value $Version -ErrorAction 'Stop'
    }
    catch {
        "Failed to update version for '$env:BHProjectName': $_.`nContinuing with existing version"
    }
}


Task 'Deploy' -Depends 'Build' {
    $lines

    $Params = @{
        Path    = "$ProjectRoot"
        Force   = $true
        Recurse = $false
    }
    Invoke-PSDeploy @Verbose @Params
}


Task 'UpdateDocumentation' -Depends 'Test' {
    $lines

    Write-Output "`nSTARTED: Updating Markdown help..."

    $null = Import-Module -Name $env:BHPSModuleManifest -Global -Force -PassThru -Verbose

    # Cleanup
    Remove-Item -Path $DocumentationPath -Recurse -Force -ErrorAction 'SilentlyContinue'
    Start-Sleep -Seconds 5
    New-Item -Path $DocumentationPath -ItemType 'Directory' | Out-Null

    $platyPSParams = @{
        Module       = $env:BHProjectName
        OutputFolder = $DocumentationPath
        NoMetadata   = $true
    }

    New-MarkdownHelp @platyPSParams -ErrorAction 'SilentlyContinue' -Verbose | Out-Null

    # Update index.md
    Write-Output "`nUpdating index.md..."
    Copy-Item -Path "$env:BHProjectPath\README.md" -Destination "$($DocumentationPath)\index.md" -Force -Verbose | Out-Null

    Write-Output "`nFINISHED: Updating Markdown help."
}


Task 'Clean' {
    $lines

    $foldersToClean = @(
        $ArtifactFolder
        $StagingFolder
    )

    # Remove folders
    foreach ($folderPath in $foldersToClean) {
        Remove-Item -Path $folderPath -Recurse -Force -ErrorAction 'SilentlyContinue'
        New-Item -Path $folderPath -ItemType 'Directory' -Force | Out-String | Write-Verbose
    }
}

Task 'CombineFunctionsAndStage' {
    $lines

    # Create folders
    New-Item -Path $StagingFolder -ItemType 'Directory' -Force | Out-String | Write-Verbose
    New-Item -Path $StagingModulePath -ItemType 'Directory' -Force | Out-String | Write-Verbose

    # Get public and private function files
    $publicFunctions = @( Get-ChildItem -Path "$env:BHModulePath\Public\*.ps1" -Recurse -ErrorAction 'SilentlyContinue' )
    $privateFunctions = @( Get-ChildItem -Path "$env:BHModulePath\Private\*.ps1" -Recurse -ErrorAction 'SilentlyContinue' )

    # Combine functions into a single .psm1 module
    $combinedModulePath = Join-Path -Path $StagingModulePath -ChildPath "$($env:BHProjectName).psm1"
    @($publicFunctions + $privateFunctions) | Get-Content | Add-Content -Path $combinedModulePath

    # Copy other required folders and files
    $pathsToCopy = @(
        Join-Path -Path $ProjectRoot -ChildPath 'Documentation'
        Join-Path -Path $ProjectRoot -ChildPath 'Examples'
        # Join-Path -Path $ProjectRoot -ChildPath 'CHANGELOG.md'
        Join-Path -Path $ProjectRoot -ChildPath 'README.md'
    )
    Copy-Item -Path $pathsToCopy -Destination $StagingFolder -Recurse

    # Copy existing manifest
    Copy-Item -Path $env:BHPSModuleManifest -Destination $StagingModulePath -Recurse
}


Task 'CreateReleaseArtifact' {
    $lines

    # Create /Release folder
    New-Item -Path $ArtifactFolder -ItemType 'Directory' -Force | Out-String | Write-Verbose

    # Get current manifest version
    try {
        $manifest = Test-ModuleManifest -Path $env:BHPSModuleManifest -ErrorAction 'Stop'
        [Version]$manifestVersion = $manifest.Version

    }
    catch {
        throw "Could not get manifest version from [$env:BHPSModuleManifest]"
    }

    # Create zip file
    try {
        $releaseFilename = "$env:BHProjectName-v$($manifestVersion.ToString()).zip"
        $releasePath = Join-Path -Path $ArtifactFolder -ChildPath $releaseFilename
        Write-Host "Creating release artifact [$releasePath] using manifest version [$manifestVersion]" -ForegroundColor 'Yellow'
        Compress-Archive -Path "$StagingFolder/*" -DestinationPath $releasePath -Force -Verbose -ErrorAction 'Stop'
    }
    catch {
        throw "Could not create release artifact [$releasePath] using manifest version [$manifestVersion]"
    }

    Write-Output "`nFINISHED: Release artifact creation."
}
