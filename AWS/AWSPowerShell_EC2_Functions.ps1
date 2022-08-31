################################################################################
#
# AWSPowerShell_EC2_Functions.ps1
#
################################################################################

Set-StrictMode -Version Latest

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

# $Regions = @("us-west-2", "us-east-2", "eu-west-1", "eu-central-1")

function getEC2InstanceCount([String[]]$Regions)
{
    foreach ($region in $Regions)
    {
        $instances = getEC2Instances $region

        if ($null -eq $instances)
        {
            "$($region),0"
        }
        else
        {
            "$($region),$($instances.Count)"
        }
    }
}

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

    $output = "$region,$ec2InstanceId"

    try
    {
        # $ec2ie.Architecture
        # $ec2ie.CpuOptions.CoreCount
        # $ec2ie.CpuOptions.ThreadsPerCore
        $hypervisor = $ec2ie.Hypervisor.Value
        # $ec2ie.InstanceType.Value
        # $ec2ie.Placement.AvailabilityZone
        $rootDeviceType = $ec2ie.RootDeviceType.Value
        $state = $ec2ie.State.Name.Value
        $virtualizationType = $ec2ie.VirtualizationType.Value

        $output += ",$($ec2i.OwnerId),$($ec2i.RequesterId),$($ec2i.ReservationId)"

        $output += ",$($ec2ie.InstanceType.Value),$($ec2ie.CpuOptions.CoreCount),$($ec2ie.CpuOptions.ThreadsPerCore)"
        $output += ",$($ec2ie.Placement.AvailabilityZone)"
        #$output += ",$($ec2ei.RootDeviceType.Value)"
        $output += ",$rootDeviceType"
        # $output += ",$($ec2ei.Hypervisor.Value),$($ec2ei.VirtualizationType.Value)"
        $output += ",$hypervisor,$virtualizationType"
        # $output += ",$($ec2ei.State.Name.Value)"
        $output += ",$state"
        $output += ",$($ec2ie.LaunchTime)"
        $output += ",$($ec2ie.UsageOperation),$($ec2ie.UsageOperationUpdateTime)"
        $output += ",$($ec2rie.LaunchTime)"
        $output += ",$($ec2rie.UsageOperation),$($ec2rie.UsageOperationUpdateTime)"        
        
        $output
    }
    catch
    {
        <#Do this if a terminating exception happens#>
        Write-Error "getEC2InstanceInfo $output"
    }
    finally
    {
        <#Do this after the try block regardless of whether an exception occurred or not#>
        # $output
    }
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
    $output += ",LaunchTime-I"
    $output += ",UsageOperation-I,UsageOperationUpdateTime-I"
    $output += ",LaunchTime_RI"
    $output += ",UsageOperation-RI,UsageOperationUpdateTime-RI"    

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

        try
        {
            foreach($tag in $ec2i.Tags)
            {
                "$region,$($ec2i.InstanceId),$($tag.Key),$($tag.Value)"
            }                
        }
        catch
        {
            Write-Error "getTags_FromEC2Instances $region $ec2"
        }
        finally
        {
            <#Do this after the try block regardless of whether an exception occurred or not#>
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

#region EC2 Volumes

# Get-EC2Volume

# SYNTAX
#     Get-EC2Volume [[-Filter] <Amazon.EC2.Model.Filter[]>] [-MaxResult <System.Int32>] [-NextToken <System.String>]
#     [-Select <System.String>] [-PassThru <System.Management.Automation.SwitchParameter>] [-NoAutoIteration
#     <System.Management.Automation.SwitchParameter>] [-EndpointUrl <System.String>] [-Region <System.Object>]
#     [-AccessKey <System.String>] [-SecretKey <System.String>] [-SessionToken <System.String>] [-ProfileName
#     <System.String>] [-ProfileLocation <System.String>] [-Credential <Amazon.Runtime.AWSCredentials>]
#     [-NetworkCredential <System.Management.Automation.PSCredential>] [<CommonParameters>]

#     Get-EC2Volume [[-VolumeId] <System.String[]>] [-Select <System.String>] [-PassThru
#     <System.Management.Automation.SwitchParameter>] [-NoAutoIteration <System.Management.Automation.SwitchParameter>]
#     [-EndpointUrl <System.String>] [-Region <System.Object>] [-AccessKey <System.String>] [-SecretKey <System.String>]
#     [-SessionToken <System.String>] [-ProfileName <System.String>] [-ProfileLocation <System.String>] [-Credential
#     <Amazon.Runtime.AWSCredentials>] [-NetworkCredential <System.Management.Automation.PSCredential>]
#     [<CommonParameters>]

# $region = "us-east-2"
# $volumeId = "vol-0630322b845eaa455"

# $volumes = Get-EC2Volume -Region $region
# $volumes | Get-Member
# $volumes | ConvertTo-Json -Depth 10 > ec2Volumes.json

# $volumes[0..2]

# $ec2Volume = Get-EC2Volume -VolumeId $volumeId -Region $region

function getEC2Volumes([String] $region)
{
    @(Get-EC2Volume -Region $region) | ForEach-Object {$_.VolumeId}
}

function getEC2VolumeInfo([String] $volumeId, [String] $region)
{
    $volume = Get-EC2Volume -VolumeId $volumeId -Region $region
    $attachments = $volume | Select-Object -Expand Attachments

    $output = "$region,$volumeId"

    try
    {
        $output += ",$($volume.AvailabilityZone)"
        $output += ",$($volume.CreateTime)"
        $output += ",$($volume.Encrypted)"
        $output += ",$($volume.FastRestored)"
        $output += ",$($volume.Iops)"
        $output += ",$($volume.KmsKeyId)"
        $output += ",$($volume.MultiAttachEnabled)"
        $output += ",$($volume.OutpostArn)"
        $output += ",$($volume.Size)"
        $output += ",$($volume.SnapshotId)"
        $output += ",$($volume.State.Value)"
        $output += ",$($volume.Throughput)"
        $output += ",$($volume.VolumeType.Value)"
        $output += ",$($volume.Status.Value)"                 

        if ($null -eq $attachments) { $output += ",0" }
        else { $output += ",$($volume.Attachments.Count)" }

        if (1 -eq $volume.Attachments.Count)
        {
            $output += ",$($attachments[0].Device),$($attachments[0].InstanceId),$($attachments[0].State.Value)"
        }
        else
        {
            $output += ",???,???,???"
            <# Action when all if and elseif conditions are false #>
        }

        # if ($null -eq $attachment) { $output += ",0" }
        # else { $output += ",$($attachment.Count)" }
    
        $output
    }
    catch
    {
        <#Do this if a terminating exception happens#>
        Write-Error "getEC2VolumeInfo $output"
    }
    finally
    {
        <#Do this after the try block regardless of whether an exception occurred or not#>
        # $output
    }
}

function getEC2VolumeInfo_FromRegion([String] $region)
{
    # Establish Column Headers
    # This needs to be in same order as field display in getEC2InstanceInfo

    $output = "Region,VolumeId"
    $output += ",AvailabilityZone"
    $output += ",CreateTime"
    $output += ",Encrypted"
    $output += ",FastRestored"
    $output += ",Iops"
    $output += ",KmsKeyId"
    $output += ",MultiAttachEnabled"
    $output += ",OutpostArn"
    $output += ",Size"
    $output += ",SnapshotId"
    $output += ",State"
    $output += ",Throughput"
    $output += ",VolumeType"
    $output += ",Status"
    $output += ",Attachments"
    $output += ",Device,InstanceId,State" 

    $output

    foreach($volumeId in (getEC2Volumes $region))
    {
        getEC2VolumeInfo $volumeId $region
    }
}

# Import-Module AWSPowerShell.NetCore
# Set-AWSCredential -ProfileName PlatformCostsRO

# $region = "us-west-2"
# $volumeId = "vol-860f2b60"

# $volume = Get-EC2Volume -VolumeId $volumeId -Region $region
# getEC2VolumeInfo $volumeId $region

# $attachments = $volume | Select-Object -Expand Attachments
# $attachment = $volume | Select-Object -Expand Attachment

# getEC2VolumeInfo_FromRegion "us-east-2"
# getEC2VolumeInfo_FromRegion "us-west-2"

#endregion EC2 Volumes

################################################################################
#
# End AWSPowerShell_EC2_Functions.ps1
#
################################################################################
