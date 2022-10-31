################################################################################
#
# AWSPowerShell_EC_Functions.ps1
#
# AWS ElasticCache
#
################################################################################

Set-StrictMode -Version Latest

#region #################### EC CacheCluster ####################

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
        # Forcing to array makes Count work even if zero entries
        $instances = @(Get-ECCacheCluster -Region $region)

        "$($region),$($instances.Count)"        

        # if ($null -eq $instances)
        # {
        #     "$($region),0"
        # }
        # else
        # {
        #     "$($region),$($instances.Count)"
        # }
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

#endregion #################### EC CacheCluster ####################

#region #################### EC Snapshot ####################

# Get-ECSnapshot

# SYNTAX
#
# Get-ECSnapshot 
#   [[-CacheClusterId] <System.String>] 
#   [[-SnapshotName] <System.String>]
#   [-ReplicationGroupId <System.String>]
#   [-ShowNodeGroupConfig <System.Boolean>]
#   [-SnapshotSource <System.String>]
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
# getECSnapshotCount $Regions

function getECSnapshotCount([String[]]$Regions)
{
    foreach ($region in $Regions)
    {
        $instances = @(Get-ECSnapshot -Region $region)

        "$($region),$($instances.Count)"
    }
}

function getECSnapshots([String]$region)
{
    @(Get-ECSnapshot -Region $region) | 
       ForEach-Object {$_.SnapshotName}
}

function getECSnapshotsFromCluster([String]$region, [string]$ecCacheClusterId)
{
    @(Get-ECSnapshot -Region $region -CacheClusterId $ecCacheClusterId) | 
       ForEach-Object {$_.SnapshotName}
}

# $Regions = @("us-west-2", "us-east-2", "eu-west-1", "eu-central-1")
# $region = $Regions[0]
# $region = $Regions[1]
# $cacheClusterId = $instances[0].CacheClusterId
# $snapshotName = "scrubber-redis-stg01"
# $snapshotName = "automatic.bcdc-debredis-stg01-001-2022-10-24-22-00"
# $snapshotName = "testing-redis"

# getECSnapshotInfo $snapshotName $region
function getECSnapshotInfo([string]$snapshotName, [string]$region)
{
    $snapShot = Get-ECSnapshot -SnapshotName $snapshotName -Region $region

    $nodeSnapshots = $snapShot | Select-Object -Expand NodeSnapshots
    $nodeSnapshotsA = @($snapShot | Select-Object -Expand NodeSnapshots)    

    # $nodeSnapshotsA.Count

    $output = "$($region),$($snapshotName)"

    try
    {
        $output += ",$($snapShot.ARN)"
        $output += ",$($snapShot.CacheClusterCreateTime)"
        $output += ",$($snapShot.CacheClusterId)"
        $output += ",$($snapShot.DataTiering.Value)"
        $output += ",$($snapShot.Engine)"
        $output += ",$($snapShot.EngineVersion)"
        $output += ",$($nodeSnapshotsA.Count)"
        
        # if (#nod.Count -ne 1)
        # {
        #     Write-Error "NodeSnapshots.Count <> 1"
        #     Write-Error $nodeSnapshotsA.Count
        # }
        # else
        # {

        # PowerShell shows all values for property on a array of things
        # Handle the mess in PowerQuery for now.

           $output += ",$($nodeSnapshots.CacheClusterId)"
           $output += ",$($nodeSnapshots.CacheNodeCreateTime)"
           $output += ",$($nodeSnapshots.CacheNodeId)"
           $output += ",$($nodeSnapshots.CacheSize)"
           $output += ",$($nodeSnapshots.NodeGroupConfiguration)"
           $output += ",$($nodeSnapshots.NodeGroupId)"
           $output += ",$($nodeSnapshots.SnapshotCreateTime)"
        # }

        $output += ",$($snapShot.NumCacheNodes)"
        $output += ",$($snapShot.NumNodeGroups)"   
             
        $output += ",$($snapShot.SnapshotSource)"          
        $output += ",$($snapShot.SnapshotStatus)"          
        $output += ",$($snapShot.SnapshotWindow)"          
        $output += ",$($snapShot.VpcId)"                                          
    }
    catch
    {
        <#Do this if a terminating exception happens#>
        Write-Error "getECSnapshotInfo $output"
    }
    finally
    {
        <#Do this after the try block regardless of whether an exception occurred or not#>
        $output
    }
}

# function getECSnapshotInfo_FromClusters($cacheClusterArray, $region)
# {
#     # Establish Column Headers
#     # This needs to be in same order as field display in getECCacheClusterInfo

#     $output = "Region,ECSnapshotName"
#     $output += ",ARN"
#     $output += ",CacheClusterCreateTime"
#     $output += ",CacheClusterId"
#     $output += ",DataTieringValue"
#     $output += ",Engine,EngineVersion"
#     $output += ",NodeSnapshots.Count"
#     $output += ",nodeSnapshots.Count"
#     $output += ",SnapshotSource"
#     $output += ",ShaphotStatus"
#     $output += ",SnapshotWindow"            
#     $output += ",VpcId"

#     $output

#     foreach($cacheClusterId in $cacheClusterArray)
#     {
#         getECCacheClusterInfo $cacheClusterId $region
#     }
# }

# $Regions = @("us-west-2", "us-east-2", "eu-west-1", "eu-central-1")
# $region = $Regions[0]

# getECSnapshotInfo_FromRegion $region

function getECSnapshotInfo_FromRegion($region)
{
    # Establish Column Headers
    # This needs to be in same order as the field display in getECSnapshotInfo

    $output = "Region,ECSnapshotName"
    $output += ",ARN"
    $output += ",CacheClusterCreateTime"
    $output += ",CacheClusterId"
    $output += ",DataTieringValue"
    $output += ",Engine,EngineVersion"

    $output += ",NS.Count"

    $output += ",NS.CacheClusterId"
    $output += ",NS.CacheNodeCreateTime"
    $output += ",NS.CacheNodeId"
    $output += ",NS.CacheSize"
    $output += ",NS.NodeGroupConfiguration"
    $output += ",NS.NodeGroupId"
    $output += ",NS.SnapshotCreateTime"

    $output += ",NumCacheNodes"
    $output += ",NumNodeGroups"

    $output += ",SnapshotSource"
    $output += ",SnapshotStatus"
    $output += ",SnapshotWindow"            
    $output += ",VpcId"

    $output

    foreach($snapshot in @(getECSnapshots $region))
    {
        getECSnapshotInfo $snapshot $region
    }
}

#endregion #################### EC Snapshot ####################

#region #################### EC ReplicationGroup ####################

# Get-ECReplicationGroup

# SYNTAX
#
# Get-ECReplicationGroup
#   [[-ReplicationGroupId] <System.String>]
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
# getECReplicaionGroupCount $Regions

function getECReplicaionGroupCount([String[]]$Regions)
{
    foreach ($region in $Regions)
    {
        $instances = @(Get-ECReplicationGroup -Region $region)

        "$($region),$($instances.Count)"
    }
}

# getECReplicationGroups $region

function getECReplicationGroups([String]$region)
{
    @(Get-ECReplicationGroup -Region $region) | 
       ForEach-Object {$_.ReplicationGroupId}
}

# $replicationGroupId = $instances[0].ReplicationGroupId
# getECReplicationGroupInfo $replicationGroupId $region

function getECReplicationGroupInfo([string]$replicationGroupId, [string]$region)
{
    $replicationGroup = Get-ECReplicationGroup -ReplicationGroupId $replicationGroupId -Region $region

    $memberClusters = @($replicationGroup | Select-Object MemberClusters)
    $nodeGroups = @($replicationGroup | Select-Object -Expand NodeGroups)

    $output = "$($region),$($replicationGroupId)"

    try
    {
        $output += ",$($replicationGroup.ARN)"
        $output += ",$($replicationGroup.AutomaticFailover.Value)"
        $output += ",$($replicationGroup.CacheNodeType)"
        $output += ",$($replicationGroup.ClusterEnabled)"
        $output += ",$($replicationGroup.DataTiering.Value)"
        $output += ",$($replicationGroup.Description)"       
        $output += ",$($replicationGroup.GlobalReplicationGroupInfo)"   

        $output += ",$($memberClusters.Count)"
        # MemberClusters is an Array
        $output += ",$($replicationGroup.MemberClusters)"

        $output += ",$($replicationGroup.MemberClustersOutpostArns)"        
        $output += ",$($replicationGroup.MultiAZ.Value)" 

        $output += ",$($nodeGroups.Count)" 
        $output += ",$($nodeGroups.NodeGroupId)" 
        $output += ",$($nodeGroups.NodeGroupId)"

        $output += ",$($replicationGroup.ReplicationGroupCreateTime)" 
        $output += ",$($replicationGroup.SnapshotRetentionLimit)" 
        $output += ",$($replicationGroup.SnapshottingClusterId)" 
        $output += ",$($replicationGroup.SnapshotWindow)" 
        $output += ",$($replicationGroup.Status)" 
        $output += ",$($replicationGroup.UserGroupIds)" 
    }
    catch
    {
        <#Do this if a terminating exception happens#>
        Write-Error "getECReplicationGroupInfo $output"
    }
    finally
    {
        <#Do this after the try block regardless of whether an exception occurred or not#>
        $output
    }
}

# $Regions = @("us-west-2", "us-east-2", "eu-west-1", "eu-central-1")
# $region = $Regions[0]

# getECReplicationGroupInfo_FromRegion $region

function getECReplicationGroupInfo_FromRegion($region)
{
    # Establish Column Headers
    # This needs to be in same order as the field display in getECReplicationGroupInfo

    $output = "Region,ReplicationGroupId"
    $output += ",ARN"
    $output += ",AutomaticFailOver"
    $output += ",CacheNodeType"
    $output += ",ClusterEnabled"
    $output += ",DataTiering"
    $output += ",Description"
    $output += ",GlobalReplicationGroupInfo"

    $output += ",MemberClustersCount"
    $output += ",MemberClusters"

    $output += ",MemberClustersOutpostArns"
    $output += ",MultiAZ"

    $output += ",NodeGroupsCount"

    $output += ",ReplicationGroupCreateTime" 
    $output += ",SnapshotRetentionLimit"  
    $output += ",SnapshottingClusterId"
    $output += ",SnapshotWindow"
    $output += ",Status"           
    $output += ",UserGroupIds"

    $output

    foreach($replicationGroup in @(getECReplicationGroups $region))
    {
        getECReplicationGroupInfo $replicationGroup $region
    }
}

# function getECSnapshotInfo_FromRegion($region)
# {
#     # Establish Column Headers
#     # This needs to be in same order as field display in getECCacheClusterInfo

#     $output = "Region,ECSnapshotName"
#     $output += ",ARN"
#     $output += ",CacheClusterCreateTime"
#     $output += ",CacheClusterId"
#     $output += ",DataTieringValue"
#     $output += ",Engine,EngineVersion"
#     $output += ",NodeSnapshots.Count"
#     $output += ",nodeSnapshots.Count"
#     $output += ",SnapshotSource"
#     $output += ",ShaphotStatus"
#     $output += ",SnapshotWindow"            
#     $output += ",VpcId"

#     $output

#     foreach($snapshot in @(getECSnapshots $region))
#     {
#         getECSnapshotInfo $snapshot $region
#     }
# }

#endregion #################### EC ReplicationGroup ####################

#region #################### EC GlobalReplicationGroup ####################

# Get-ECGlobalReplicationGroup
#
# SYNTAX
#
# Get-ECGlobalReplicationGroup 
#   [[-GlobalReplicationGroupId] <System.String>] 
#   [-ShowMemberInfo <System.Boolean>] 
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
# getECGlobalReplicaionGroupCount $Regions

function getECGlobalReplicaionGroupCount([String[]]$Regions)
{
    foreach ($region in $Regions)
    {
        $instances = Get-ECGlobalReplicationGroup -Region $region

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

# getECGlobalReplicationGroups $region

function getECBlobalReplicationGroups([String]$region)
{
    @(Get-ECGlobalReplicationGroup -Region $region) | 
       ForEach-Object {$_.SnapshotName}
}

#endregion #################### EC GlobalReplicationGroup ####################

################################################################################
#
# End AWSPowerShell_EC_Functions.ps1
#
################################################################################
