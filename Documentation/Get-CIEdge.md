# Get-CIEdge

## SYNOPSIS
Retrieves vCloud Edges.

## SYNTAX

```
Get-CIEdge [[-Name] <String[]>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves vCloud Edges, including View and XML configuration.

## EXAMPLES

### EXAMPLE 1
```
Get-CIEdge
```

Returns all vShield Edges.

### EXAMPLE 2
```
Get-CIEdge -Name 'Edge01'
```

Returns a single vShield Edge.

### EXAMPLE 3
```
Get-CIEdge -Name 'Edge01', 'Edge02'
```

Returns multiple vShield Edges.

## PARAMETERS

### -Name
Specifies the name of the vShield Edge you want to retrieve.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String
## OUTPUTS

### System.Management.Automation.PSCustomObject
## NOTES
Author: Adam Rush

## RELATED LINKS
