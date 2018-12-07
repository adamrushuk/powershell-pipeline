$ProjectRoot = $env:BHProjectPath
$ModuleRoot = $env:BHModulePath
$ModuleName = $env:BHProjectName
$ModulePath = $env:BHPSModuleManifest
Import-Module $ModulePath -Force

Describe "Module Tests for $ModuleName" {
    It 'Passes Test-ModuleManifest' {
        { $Result = Test-ModuleManifest -Path $ModulePath -ErrorAction Stop } | Should Not Throw
    }

    It "Can import the Module" {
        $Module = Import-Module $ModulePath -Force -PassThru | Where-Object {$_.Name -eq $ModuleName}
        $Module.Name | Should be $ModuleName
    }
}

Describe "Comment-based help for $ModuleName" {

    $Functions = Get-Command -Module $ModuleName -CommandType Function

    foreach ($Func in $Functions) {
        $Help = Get-Help $Func.Name

        Context $Help.Name {
            it "Has Synopsis" {
                $Help.Synopsis | Should Not BeNullOrEmpty
            }

            it "Has Description" {
                $Help.Description | Should Not BeNullOrEmpty
            }

            foreach ($Parameter in $Help.Parameters.Parameter) {
                if ($Parameter -notmatch 'whatif|confirm') {
                    it "Has a Parameter description for '$($Parameter.Name)'" {
                        $Parameter.Description.Text | Should Not BeNullOrEmpty
                    }
                }
            }

            it "Has Examples" {
                $Help.Examples | Should Not BeNullOrEmpty
            }
        }
    } # End foreach function
} # End Comment-based help
