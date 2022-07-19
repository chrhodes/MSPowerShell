################################################################################
#
# AWSPowerShell_Utility_Functions.ps1
#
################################################################################

Set-StrictMode -Version Latest

#Extract the relevant name from the ARN

function getClusterName([string]$line)
{
    # arn:aws:ecs:us-west-2:049751716774:cluster/awseb-zuora-ep-sbx-21183-jp6vtkp5kw

    $start = $line.LastIndexOf(":")
    $start += ":cluster/".Length
    $length = $line.Length - $start
    $line.Substring($start, $length)
}

function getContainerInstanceName([string]$line)
{
    if ($null -eq $line) { return ""}
    if ($line.Length -eq 0) {return ""}
    else
    {
        $start = $line.LastIndexOf(":")
        $start += ":container-instance/".Length
        $length = $line.Length - $start
        $line.Substring($start, $length)  
    }
    
    # try 
    # {
    #     # [OutputType([String])]
    #     $start = $line.LastIndexOf(":")
    #     $start += ":container-instance/".Length
    #     $length = $line.Length - $start
    #     $line.Substring($start, $length)        
    # }
    # catch
    # {
    #     "XXX,$line,$start,$length"
    # }
    # finally
    # {
    #     <#Do this after the try block regardless of whether an exception occurred or not#>
    # }

}

function getRoleName([string]$line)
{
    $start = $line.LastIndexOf(":")
    $start += ":role/".Length
    $length = $line.Length - $start
    $line.Substring($start, $length)
}

function getServiceName([string]$line)
{
    $start = $line.LastIndexOf(":")
    $start += ":service/".Length
    $length = $line.Length - $start
    $line.Substring($start, $length)
}
function getTaskName([string]$line)
{
    $start = $line.LastIndexOf(":")
    $start += ":task/".Length
    $length = $line.Length - $start
    $line.Substring($start, $length)
}

# TODO - This needs work as the TaskDefinition may end with a :Version
# See :21 infra

# $tdn = "arn:aws:ecs:us-west-2:049751716774:task-definition/daco-prod02-dc-event:21"
# $tdn = "arn:aws:ecs:us-west-2:049751716774:task-definition/api-event:4"
function getTaskDefinitionName([string]$line)
{
    $lastIndex = $line.LastIndexOf(":")
    $secondLastIndex = $line.Substring(0, $lastIndex).LastIndexOf(":")
    
    $start = $secondLastIndex + ":task-definition/".Length   
    $length = $lastIndex - $start
     
    # $taskDef.Length
    # $secondLastIndex
    # $start
    # $lastIndex    
    # $length
    
    $line.Substring($start, $length)
    
}

# NB. This includes the Version, e.g. task:42
function getTaskDefinitionFullName([string]$line)
{
    $lastIndex = $line.LastIndexOf(":")
    $secondLastIndex = $line.Substring(0, $lastIndex).LastIndexOf(":")
    
    $start = $secondLastIndex + ":task-definition/".Length   
    $length = $line.Length - $start
     
    # $taskDef.Length
    # $secondLastIndex
    # $start
    # $lastIndex    
    # $length
    
    $line.Substring($start, $length)
}

function getRegionAbbreviation([string] $region)
{
    switch ($region)
    {
        "us-west-2" { "usw2" }
        "us-east-2" { "use2" }
        "eu-west-1" { "euw1" }
        "eu-central-1" { "euc1" }
        default { "XXX" }
    }
}

################################################################################
#
# End AWSPowerShell_Utility_Functions.ps1
#
################################################################################