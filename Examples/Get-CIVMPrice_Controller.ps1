# Retrieves custom pricing options for vCloud VMs
# Load module
Import-Module 'PSvCloud'

# Vars
$ExportPath = "$($env:TEMP)\PriceReport-$(Get-Date -Format 'dd-MM-yyyy_HH-mm').csv"
$vCloudServer = 'vCloudServer01'

# Connect to vCloud
Connect-CIServer -Server $vCloudServer

# Get all Orgs starting with 11-22-
$Orgs = Get-Org -Name '11-22-*'

# Get all OrgVDCs with ENHANCED in the name
$OrgVDCs = $Orgs | Get-OrgVdc -Name '*ENHANCED*'

# Get CIVMs within all OrgVDCs
$CIVMs = $OrgVDCs | Get-CIVM

# Get prices
$Report = $CIVMs | Get-CIVMPrice -Verbose

# Export report
$Report | Export-Csv -Path $ExportPath -UseCulture -NoTypeInformation
Write-Host "Report exported to [$ExportPath]" -ForegroundColor 'Yellow'

# Close connection
Disconnect-CIServer -Server $vCloudServer -Confirm:$false
