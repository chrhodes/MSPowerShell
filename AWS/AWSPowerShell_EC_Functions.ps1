################################################################################
#
# AWSPowerShell_EC_Functions.ps1
#
# AWS ElasticCache
#
################################################################################

Set-StrictMode -Version Latest

# Get-ECCacheCluster

# SYNTAX
#
# Get-ECCacheCluster 
#   [[-CacheClusterId] <System.String>] 
#   [-ShowCacheClustersNotInReplicationGroup <System.Boolean>] 
#   [-ShowCacheNodeInfo <System.Boolean>] 
#   [-Marker <System.String>] 
#   [-MaxRecord <System.Int32>] 
#   [-Select <System.String>] 
#   [-PassThru <System.Management.Automation.SwitchParameter>] 
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

# $Regions = @("us-west-2", "us-east-2", "eu-west-1", "eu-central-1")
# $region = $Regions[0]

function getECCacheClusterCount([String[]]$Regions)
{
    foreach ($region in $Regions)
    {
        $instances = Get-ECCacheCluster -Region $region

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

function getECCacheClusters([String]$region)
{
    @(Get-ECCacheCluster -Region $region) | 
       ForEach-Object {$_.CacheClusterId}
}

# $cacheClusterId = $instances[0].CacheClusterId

function getECCacheClusterInfo($cacheClusterId, $region)
{
    $cacheCluster = Get-ECCacheCluster -CacheClusterId $cacheClusterId -Region $region -ShowCacheNodeInfo $true
    # $cacheClusterDetailed = Get-ECCacheCluster -CacheClusterId $cacheClusterId -Region $region -ShowCacheNodeInfo $true

    # $ec2i = Get-EC2Instance -InstanceID $ec2InstanceId -Region $region
    # $ec2ie = $ec2i | Select-Object -Expand Instances
    # $ec2rie = $ec2i | Select-Object -Expand RunningInstance

    $output = "$region,$cacheClusterId"

    try
    {
        $output += ",$($cacheCluster.ARN)"
        $output += ",$($cacheCluster.CacheClusterCreateTime)"
        $output += ",$($cacheCluster.CacheClusterStatus)"
        $output += ",$($cacheCluster.CacheNodes.Count)"
        $output += ",$($cacheCluster.CacheNodeType)"
        $output += ",$($cacheCluster.Engine)"
        $output += ",$($cacheCluster.NumCacheNodes)"
        $output += ",$($cacheCluster.PreferredAvailabilityZone)"
        $output += ",$($cacheCluster.ReplicationGroupId)"
        $output += ",$($cacheCluster.SnapshotRetentionLimit)"                            
   
        # $output
    }
    catch
    {
        <#Do this if a terminating exception happens#>
        Write-Error "getECCacheClusterInfo $output"
    }
    finally
    {
        <#Do this after the try block regardless of whether an exception occurred or not#>
        $output
    }
}

function getECCacheClusterInfo_FromClusters($cacheClusterArray, $region)
{
    # Establish Column Headers
    # This needs to be in same order as field display in getECCacheClusterInfo

    $output = "Region,ECCacheClusterID"
    $output += ",ARN,CacheClusterCreateTime,CacheClusterStatus"
    $output += ",CacheNodeCount,CacheNodeType"
    $output += ",Engine"
    $output += ",NumCacheNodes"
    $output += ",PreferredAvailabilityZone"
    $output += ",ReplicationGroupId"
    $output += ",SnapshotRetentionLimit"

    $output

    foreach($cacheClusterId in $cacheClusterArray)
    {
        getECCacheClusterInfo $cacheClusterId $region
    }
}

################################################################################
#
# End AWSPowerShell_EC_Functions.ps1
#
################################################################################
