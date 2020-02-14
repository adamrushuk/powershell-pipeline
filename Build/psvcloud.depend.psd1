@{
    # Defaults for all dependencies
    PSDependOptions  = @{
        Target     = 'CurrentUser'
        Parameters = @{
            # Can use a local repository for offline support
            Repository         = 'PSGallery'
            # SkipPublisherCheck = $true
        }
    }

    # Dependency Management modules
    # PackageManagement = '1.4.6'
    # PowerShellGet     = '2.2.3'

    # Common modules
    BuildHelpers     = '2.0.11'
    Pester           = '4.10.1'
    PlatyPS          = '0.14.0'
    psake            = '4.9.0'
    PSDeploy         = '1.0.3'
    PSScriptAnalyzer = '1.18.3'
    # 'VMware.VimAutomation.Cloud' = '11.0.0.10379994'
}
