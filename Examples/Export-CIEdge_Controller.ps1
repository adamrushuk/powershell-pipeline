<#
.SYNOPSIS
Exports the configuration of an vShield Edge.

.DESCRIPTION
Exports the configuration of an vShield Edge.
The XML file is saved to the location specified in Path.

.PARAMETER Name
Specifies an array of vShield Edge names.

.PARAMETER Path
Specifies the path to where the XML configuration file will be saved.

.EXAMPLE
Export-CIEdge_Controller.ps1 -Name 'Edge01'

.NOTES
Author: Adam Rush
#>
[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Name,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Path
)

# TODO