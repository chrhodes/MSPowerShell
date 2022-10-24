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

# $outputDir = "C:\Users\crhodes\My Drive\Budget & Costs\CSV Files\Staging\2022.10.24"
# $Regions = @("us-west-2", "us-east-2", "eu-west-1", "eu-central-1")


function gatherEC_CacheClusterData([string]$outputDir, [string[]]$regions)
{
    $startTime = Get-Date

    "Start Time: " + $startTime

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

#endregion #################### EC Data ####################

################################################################################
#
# Gather_Data_Functions.ps1
#
################################################################################