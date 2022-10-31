################################################################################
#
# Gather_ECData_Functions.ps1
#
#
# NB. These functions do not check if the $outputDir exists.
# Handle in the caller
#
################################################################################

Set-StrictMode -Version Latest

#region #################### EC Data ####################

#region #################### EC CacheCluster ####################

# $outputDir = "C:\Users\crhodes\My Drive\Budget & Costs\CSV Files\Staging\2022.10.25"
# $Regions = @("us-west-2", "us-east-2", "eu-west-1", "eu-central-1")

function gatherEC_CacheClusterData([string]$outputDir, [string[]]$regions)
{
    $startTime = Get-Date

    "Start Time (gatherEC_CacheClusterData): " + $startTime

    ">>>>>>>>>> Gathering EC_CacheClusterInfo"

    foreach ($region in $Regions)
    {
        Set-Location $outputDir
        "    ---- Processing $region"

        $clusters = @(getECCacheClusters $region)

        getECCacheClusterInfo_FromClusters $clusters $region `
            > "EC_CacheClusterInfo_$(getRegionAbbreviation $region).csv"
    }

    # TODO(crhodes)
    # Add more sections here

    $endTime = Get-Date

    "Elapsed Time: " + ($endTime - $startTime | Select-Object Hours, Minutes, Seconds)
}

#endregion #################### EC CacheCluster ####################

#region #################### EC ReplicationGroup ####################

# $outputDir = "C:\Users\crhodes\My Drive\Budget & Costs\CSV Files\Staging\2022.10.24"
# $Regions = @("us-west-2", "us-east-2", "eu-west-1", "eu-central-1")
# gatherEC_ReplicationGroupData $outputDir $Regions

function gatherEC_ReplicationGroupData([string]$outputDir, [string[]]$regions)
{
    $startTime = Get-Date

    "Start Time (gatherEC_ReplicationGroupData): " + $startTime

    ">>>>>>>>>> Gathering EC_ReplicationGroupInfo"

    foreach ($region in $Regions)
    {
        Set-Location $outputDir
        "    ---- Processing $region"

        # $repGroups = @(getECReplicationGroups $region)

        getECReplicationGroupInfo_FromRegion $region `
            > "EC_ReplicationGroupInfo_$(getRegionAbbreviation $region).csv"
    }

    # TODO(crhodes)
    # Add more sections here

    $endTime = Get-Date

    "Elapsed Time: " + ($endTime - $startTime | Select-Object Hours, Minutes, Seconds)
}

#endregion #################### EC ReplicationGroup ####################

#region #################### EC Snapshot ####################

# $outputDir = "C:\Users\crhodes\My Drive\Budget & Costs\CSV Files\Staging\2022.10.25"
# $Regions = @("us-west-2", "us-east-2", "eu-west-1", "eu-central-1")
# gatherEC_SnapshotData $outputDir $Regions

function gatherEC_SnapshotData([string]$outputDir, [string[]]$regions)
{
    $startTime = Get-Date

    "Start Time (gatherEC_SnapshotData): " + $startTime

    ">>>>>>>>>> Gathering EC_SnapshotInfo"

    foreach ($region in $Regions)
    {
        Set-Location $outputDir
        "    ---- Processing $region"

        # $clusters = @(getECCacheClusters $region)

        getECSnapshotInfo_FromRegion $region `
            > "EC_SnapshotInfo_$(getRegionAbbreviation $region).csv"
    }

    # TODO(crhodes)
    # Add more sections here

    $endTime = Get-Date

    "Elapsed Time: " + ($endTime - $startTime | Select-Object Hours, Minutes, Seconds)
}

#endregion #################### EC Snapshot ####################

#endregion #################### EC Data ####################

################################################################################
#
# Gather_Data_Functions.ps1
#
################################################################################