################################################################################
#
# AWSPowerShell_EC2Functions.ps1
#
################################################################################

# Get-EC2Instance

# SYNTAX
#
# Get-EC2Instance 
#   [[-InstanceId] <System.Object[]>] 
#   [[-Filter] <Amazon.EC2.Model.Filter[]>]
#   [-MaxResult <System.Int32>]
#   [-NextToken <System.String>]
#   [-Select <System.String>]
#   [-PassThru <System.Management.Automation.SwitchParameter>]
#   [-EndpointUrl <System.String>]
#   [-Region <System.Object>]
#   [-AccessKey <System.String>]
#   [-SecretKey <System.String>]
#   [-SessionToken <System.String>]
#   [-ProfileName <System.String>]
#   [-ProfileLocation <System.String>]
#   [-Credential <Amazon.Runtime.AWSCredentials>]
#   [-NetworkCredential <System.Management.Automation.PSCredential>]
#   [<CommonParameters>]
#

function getEC2Instances([String]$region)
{
    @(Get-EC2Instance -Region $region) | 
        Select-Object -Expand Instances | ForEach-Object {$_.InstanceId}
}

function getEC2InstanceInfo($ec2InstanceId, $region)
{
    $ec2i = Get-EC2Instance -InstanceID $ec2InstanceId -Region $region
    $ec2ie = $ec2i | Select-Object -Expand Instances
    $ec2rie = $ec2i | Select-Object -Expand RunningInstance

    # $ec2ie.Architecture
    # $ec2ie.CpuOptions.CoreCount
    # $ec2ie.CpuOptions.ThreadsPerCore
    $hypervisor = $ec2ie.Hypervisor.Value
    # $ec2ie.InstanceType.Value
    # $ec2ie.Placement.AvailabilityZone
    $rootDeviceType = $ec2ie.RootDeviceType.Value
    $state = $ec2ie.State.Name.Value
    $virtualizationType = $ec2ie.VirtualizationType.Value

    $output = "$region,$ec2InstanceId"

    $output += ",$($ec2i.OwnerId),$($ec2i.RequesterId),$($ec2i.ReservationId)"

    $output += ",$($ec2ie.InstanceType.Value),$($ec2ie.CpuOptions.CoreCount),$($ec2ie.CpuOptions.ThreadsPerCore)"
    $output += ",$($ec2ie.Placement.AvailabilityZone)"
    #$output += ",$($ec2ei.RootDeviceType.Value)"
    $output += ",$rootDeviceType"
    # $output += ",$($ec2ei.Hypervisor.Value),$($ec2ei.VirtualizationType.Value)"
    $output += ",$hypervisor,$virtualizationType"
    # $output += ",$($ec2ei.State.Name.Value)"
    $output += ",$state"

    $output
}

function getEC2InstanceInfo_FromInstances($instanceArray, $region)
{
    # Establish Column Headers
    # This needs to be in same order as field display in getEC2InstanceInfo

    $output = "Region,Ec2InstanceID"
    $output += ",OwnerId,RequesterId,ReservationId"
    $output += ",InstanceType,CoreCount,ThreadsPerCore"
    $output += ",AvailabilityZone"
    $output += ",RootDeviceType"
    $output += ",Hypervisor,VirualizationType"
    $output += ",State"

    $output

    foreach($ec2Instance in $instanceArray)
    {
        getEC2InstanceInfo $ec2Instance $region
    }
}

function getTags_FromEC2Instances([string[]]$instanceArray, [string]$region)
{
    Write-Output "Region,InstanceId,Key,Value"

    foreach($ec2 in $instanceArray)
    {
        $ec2i = Get-EC2Instance -InstanceID $ec2 -Region $region |
            Select-Object -ExpandProperty Instances

        foreach($tag in $ec2i.Tags)
        {
            "$region,$($ec2i.InstanceId),$($tag.Key),$($tag.Value)"
        }
    }
}

function getTags_FromClusters([string[]]$clusterArray, [string]$region)
{
    Write-Output "Region,Cluster,Key,Value"

    foreach($cluster in $clusterArray)
    {
        $json = Get-ECSClusterDetail -Cluster $cluster -Region $region -Include TAGS 

        $clusters = $json | Select-Object -Expand Clusters
        $tags = $clusters | Select-Object -Expand Tags

        foreach($tag in $tags)
        {
            "$region,$cluster,$($tag.Key),$($tag.Value)"
        }
    }
}

# Get-EC2InstanceType

# SYNTAX
#
#  Get-EC2InstanceType 
#   [-Filter <Amazon.EC2.Model.Filter[]>]
#   [-InstanceType <System.String[]>]
#   [-MaxResult <System.Int32>]     
#   [-NextToken <System.String>]
#   [-Select <System.String>]
#   [-NoAutoIteration <System.Management.Automation.SwitchParameter>]    
#   [-EndpointUrl <System.String>]
#   [-Region <System.Object>]
#   [-AccessKey <System.String>]
#   [-SecretKey <System.String>]
#   [-SessionToken <System.String>]
#   [-ProfileName <System.String>]
#   [-ProfileLocation <System.String>]
#   [-Credential <Amazon.Runtime.AWSCredentials>]
#   [-NetworkCredential <System.Management.Automation.PSCredential>]
#   [<CommonParameters>]
#

function getEC2InstanceTypes([string]$region)
{
    $instanceTypes = Get-EC2InstanceType -Region $region
    # $instanceTypes | Get-Member
    # $instType = $instanceTypes[0]

    foreach($instType in $instanceTypes)
    {
        #$json = $instType | ConvertTo-Json -Depth 10
        $output = "$region,$($instType.InstanceType)"
        $output += ",$($instType.CurrentGeneration)"
        $output += ",$($instType.BareMetal)"  

        $output += ",$($instType.ProcessorInfo.SustainedClockSpeedInGhz)"
        $output += ",$($instType.VCpuInfo.DefaultCores)"
        $output += ",$($instType.VCpuInfo.DefaultThreadsPerCore)"
        $output += ",$($instType.VCpuInfo.DefaultVCpus)"
        $output += ",$($instType.MemoryInfo.SizeInMiB / 1024)"
        $output += ",$($instType.BurstablePerformanceSupported)"        

        $output += ",$($instType.EbsInfo.EbsOptimizedSupport)" 
        $output += ",$($instType.EbsInfo.EncryptionSupport)" 
        $output += ",$($instType.EbsInfo.NvmeSupport)" 

        $output += ",$($instType.InstanceStorageSupported)" 

        if($true -eq $instType.InstanceStorageSupported )
        {
            $output += ",$($instType.InstanceStorageInfo.TotalSizeInGB)"
            $output += ",$($instType.InstanceStorageInfo.EncryptionSupport)"
            $output += ",$($instType.InstanceStorageInfo.NvmeSupport)"            
        }
        else
        {
            $output += ",,,"
        }

        $output
    }
}

################################################################################
#
# End AWSPowerShell_EC2Functions.ps1
#
################################################################################
