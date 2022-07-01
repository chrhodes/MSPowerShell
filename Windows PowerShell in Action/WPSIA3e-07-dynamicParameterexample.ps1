function dynamicParameterExample
{
    [cmdletbinding()]
    param (
        [String]$name,
        [String]$path
    )

    dynamicparam
    {
        if ($path -match "^HKLM:")
        {
            $attributes = New-Object `
                System.Management.Automation.ParameterAttribute `
                -Property @{
                    ParameterSetName = "set1"
                    Mandatory = $false
                }

            $attributeCollection = New-Object `
                System.Collections.ObjectModel.Collection[System.Attribute]
            $attributeCollection.Add($attributes)

            $dynParam1 = New-Object `
	           System.Management.Automation.RuntimeDefinedParameter `
	           dp1,int, $attributeCollection

            $paramDictionary = New-Object `
                Management.Automation.RuntimeDefinedParameterDictionary
            $paramDictionary.Add("dp1", $dynParam1)
        
            $paramDictionary
        }
    }
    
    end {  $psboundparameters }
}