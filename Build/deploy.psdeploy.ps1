# Config file for PSDeploy
# Set-BuildEnvironment from BuildHelpers module has populated ENV:BHModulePath and related variables
# Publish to gallery with a few restrictions
if (
    $env:BHPSModulePath -and
    $env:BHBranchName -eq "master" -and
    $env:BHBuildSystem -ne 'Unknown' # -and
    # $env:BHCommitMessage -match '!deploy'
) {

    Deploy PublishModule {
        By PSGalleryModule {
            FromSource $env:BHPSModulePath
            To $env:REPO_NAME
            WithOptions @{
                ApiKey = $env:REPO_API_KEY
                # Credential = (Get-Credential)
            }
        }
    }

} else {
    "Skipping deployment: To deploy, ensure that...`n" +
    "`t* You are committing to the master branch (Current: $env:BHBranchName) `n" +
    "`t* You are in a known build system (Current: $env:BHBuildSystem)`n" +
    "`t* [DISABLED RULE] Your commit message includes !deploy (Current: $env:BHCommitMessage)" |
    Write-Host
}
