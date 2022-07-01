using namespace System.Management.Automation

class FixCase : ArgumentTransformationAttribute 
{
    [object] Transform( 
        [EngineIntrinsics] $engineIntrinsics, 
        [object] $inputData)
    {
        [string] $data = $inputData -as [string]
        if (-not $data) {
            throw [PSArgumentNullException]::new("inputData") 
        }
        return $data.SubString(0,1).ToUpper() + 
            $data.Substring(1).ToLower()
    }
}

function AutocapPet
{
    param (
        [FixCase()] 
        [string]
            $petType
    )
    return $petType
}
