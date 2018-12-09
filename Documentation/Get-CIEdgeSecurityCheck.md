# Get-CIEdgeSecurityCheck

## SYNOPSIS
Retrieves basic security information for a vShield edge

## SYNTAX

### ByName (Default)
```
Get-CIEdgeSecurityCheck -Name <String[]> [<CommonParameters>]
```

### Standard
```
Get-CIEdgeSecurityCheck -CIEdge <Object> [<CommonParameters>]
```

## DESCRIPTION
Retrieves basic vShield edge security information including:
- FW enabled (True/False)
- FW default action (Allow/Drop)
- Any insecure FW rules

## EXAMPLES

### EXAMPLE 1
```
Get-CIEdge | Get-CIEdgeSecurityCheck
```

Returns firewall security information for the pipeline value of the Get-CIEdge command.

### EXAMPLE 2
```
Get-CIEdgeSecurityCheck -Name "Edge01"
```

Returns firewall security information for the specified vShield edge.

### EXAMPLE 3
```
Get-CIEdgeSecurityCheck -Name 'Edge01', 'Edge02'
```

Returns firewall security information for multiple vShield Edges.

## PARAMETERS

### -Name
Specifies the name of the vShield Edge you want to retrieve.

```yaml
Type: String[]
Parameter Sets: ByName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CIEdge
Specifies the PSCustomObject output of Get-CIEdge.

```yaml
Type: Object
Parameter Sets: Standard
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Management.Automation.PSCustomObject
## OUTPUTS

### System.Management.Automation.PSCustomObject
## NOTES
Author: Matt Horgan

## RELATED LINKS
