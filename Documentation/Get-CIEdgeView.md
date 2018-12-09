# Get-CIEdgeView

## SYNOPSIS
Gets the Edge View.

## SYNTAX

```
Get-CIEdgeView [[-Name] <String[]>] [<CommonParameters>]
```

## DESCRIPTION
Gets the Edge View using the Search-Cloud cmdlet.

## EXAMPLES

### EXAMPLE 1
```
Get-CIEdgeView
```

Returns all vShield Edges.

### EXAMPLE 2
```
Get-CIEdgeView -Name 'Edge01'
```

Returns a single vShield Edge.

### EXAMPLE 3
```
Get-CIEdgeView -Name 'Edge01', 'Edge02'
```

Returns multiple vShield Edges.

## PARAMETERS

### -Name
Specifies a single vShield Edge name.

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

### VMware.VimAutomation.Cloud.Views.Gateway
## NOTES
Author: Adam Rush

## RELATED LINKS
