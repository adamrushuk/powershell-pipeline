# Get public and private function files
$Public = @( Get-ChildItem -Path "$PSScriptRoot\Public\*.ps1" -Recurse -ErrorAction 'SilentlyContinue' )
$Private = @( Get-ChildItem -Path "$PSScriptRoot\Private\*.ps1" -Recurse -ErrorAction 'SilentlyContinue' )

# Dot source the files
foreach ($functionFile in @($Public + $Private)) {
    try {
        . $functionFile.fullname
    } catch {
        Write-Error -Message "Failed to import function $($functionFile.fullname): $_"
    }
}

# Export the Public modules
Export-ModuleMember -Function $Public.Basename
