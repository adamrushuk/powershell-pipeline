# Get-CIVMPrice

## SYNOPSIS
Retrieves pricing options for vCloud VMs.

## SYNTAX

```
Get-CIVMPrice [-CIVM] <Object[]> [[-PricingMatrix] <Hashtable>] [[-ValidCPUMemoryMap] <Hashtable>]
 [<CommonParameters>]
```

## DESCRIPTION
Retrieves pricing options for vCloud VMs, by comparing it's CPU count and Memory against a pricing
matrix for different tiers.

## EXAMPLES

### EXAMPLE 1
```
Get-CIVM | Get-CIVMPrice
```

Returns prices for all CIVMs.

### EXAMPLE 2
```
Get-CIVMPrice -CIVM $CIVM01, $CIVM02
```

Returns prices for two CIVMs.

## PARAMETERS

### -CIVM
One or more vCloud VM objects.

```yaml
Type: Object[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -PricingMatrix
A hashtable pricing matrix for different tiers, with the keys being a concatenation of CPU count and
Memory in GB.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: @{
            10    = @{Size = 'Micro'; Essential = 0.01; Power = 0.02; Priority = 0.03}
            12    = @{Size = 'Tiny'; Essential = 0.03; Power = 0.09; Priority = 0.135}
            24    = @{Size = 'Small'; Essential = 0.04; Power = 0.12; Priority = 0.18}
            48    = @{Size = 'Medium'; Essential = 0.06; Power = 0.22; Priority = 0.33}
            416   = @{Size = 'Medium High Memory'; Essential = 0.14; Power = 0.35; Priority = 0.520}
            816   = @{Size = 'Large'; Essential = 0.18; Power = 0.45; Priority = 0.675}
            832   = @{Size = 'Large High Memory'; Essential = 0.35; Power = 0.55; Priority = 1.125}
            848   = @{Size = 'Tier 1 Apps Small'; Essential = 0.50; Power = 0.60; Priority = 1.575}
            864   = @{Size = 'Tier 1 Apps Medium'; Essential = 0.70; Power = 0.99; Priority = 2.085}
            896   = @{Size = 'Tier 1 Apps Large'; Essential = 0.95; Power = 1.45; Priority = 2.675}
            12128 = @{Size = 'Tier 1 Apps Extra Large'; Essential = 1.30; Power = 2.30; Priority = 'NA'}
        }
Accept pipeline input: False
Accept wildcard characters: False
```

### -ValidCPUMemoryMap
A hashtable to validate acceptable CPU / Memory configurations.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: @{
            1  = @(0, 2)
            2  = @(4)
            4  = @(8, 16)
            8  = @(16, 32, 48, 64, 96)
            12 = @(128)
        }
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Object
## OUTPUTS

### PSCustomObject
## NOTES
Author: Adam Rush

## RELATED LINKS
