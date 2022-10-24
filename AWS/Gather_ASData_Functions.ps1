################################################################################
#
# Gather_ASData_Functions.ps1
#
#
# NB. These functions do not check if the $outputDir exists.
# Handle in the caller
#
################################################################################

Set-StrictMode -Version Latest

#region #################### AS Data ####################

#region #################### AS AutoScalingGroup ####################

# $region = "us-west-2"
# $asGroup = "zin-prod-asg"
# $asInstance = "i-04be99315aebb9dd3"

# getAutoScalingGroupInfo $asGroup $region

# Get-ASAutoScalingInstance -InstanceId $asGroup -Region $region
# Get-ASAutoScalingInstance -InstanceId $asInstance -Region $region

# $asInstances = $asInstances[0..5]
# getASAutoScalingInstanceInfo_FromInstances $asInstances $region

# getASAutoScalingInstanceInfo $asInstance $region

function gatherAS_Data([string]$outputDir, [string[]]$Regions)
{
    $startTime = Get-Date

    "Start Time: " + $startTime

    ">>>>>>>>>> Gathering AS_AutoScaling_Groups"

    foreach ($region in $Regions)
    {
        Set-Location $outputDir
        "    ---- Processing $region"

        $asGroups = @(getAutoScalingGroups $region)
        
        getAutoScalingGroupInfo_FromInstances $asGroups $region  `
            > "AS_AutoScaling_Groups_$(getRegionAbbreviation $region).csv"
    }

    ">>>>>>>>>> Gathering AS_AutoScaling_Instances"

    foreach ($region in $Regions)
    {
        Set-Location $outputDir
        "    ---- Processing $region"

        $asInstances = @(getAutoScalingInstances $region)
        
        getASAutoScalingInstanceInfo_FromInstances $asInstances $region  `
            > "AS_AutoScaling_Instances_$(getRegionAbbreviation $region).csv"
    }

    $endTime = Get-Date

    "Elapsed Time: " + ($endTime - $startTime | Select-Object Hours, Minutes, Seconds)
}

#endregion #################### AS AutoScalingGroup ####################

#endregion #################### AS Data ####################

################################################################################
#
# Gather_ASData_Functions.ps1
#
################################################################################