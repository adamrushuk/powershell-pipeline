# Get-CIEdgeXML

## SYNOPSIS
Gets the vCloud Edge configuration XML.

## SYNTAX

```
Get-CIEdgeXML [-CIEdgeView] <Gateway> [<CommonParameters>]
```

## DESCRIPTION
Gets the vCloud Edge configuration XML using the REST API.

## EXAMPLES

### EXAMPLE 1
```
Get-CIEdgeXML -CIEdgeView $CIEdgeView
```

Gets the Edge XML configuration for Edge object in $CIEdgeView

### EXAMPLE 2
```
$CIEdgeView | Get-CIEdgeXML
```

Gets the Edge XML configuration for Edge object in $CIEdgeView

## PARAMETERS

### -CIEdgeView
CIEdgeView object for SessionKey and Name properties.

```yaml
Type: Gateway
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### VMware.VimAutomation.Cloud.Views.Gateway
## OUTPUTS

### System.Xml.XmlDocument
## NOTES
Author: Adam Rush

## RELATED LINKS
