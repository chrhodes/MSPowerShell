################################################################################
#
# Gather_Data_Functions.ps1
#
#
# NB. These functions do not check if the $outputDir exists.
# Handle in the caller
#
################################################################################

Set-StrictMode -Version Latest

#region #################### EC2 Data ####################

#region #################### EC2 Instance ####################

function gatherEC2_Data([string]$outputDir, [string[]]$regions)
{
    $startTime = Get-Date

    "Start Time: " + $startTime

    ">>>>>>>>>> Gathering EC2_InstanceInfo"

    foreach ($region in $Regions)
    {
        Set-Location $outputDir
        "    ---- Processing $region"
    
        $instances = @(getEC2Instances $region)
    
        getEC2InstanceInfo_FromInstances $instances $region `
            > "EC2_InstanceInfo_$(getRegionAbbreviation $region).csv"
    }
    
    ">>>>>>>>>> Gathering EC2_Tags_Instance"

    foreach ($region in $Regions)
    {
        Set-Location $outputDir
        "    ---- Processing $region"
    
        $instances = @(getEC2Instances $region)
    
        getTags_FromEC2Instances $instances $region `
            > "EC2_Tags_Instance_$(getRegionAbbreviation $region).csv"
    }   
    
    $endTime = Get-Date

    "Elapsed Time: " + ($endTime - $startTime | Select-Object Hours, Minutes, Seconds)
}

#endregion #################### EC2 Instance ####################

#region #################### EC2 Volume ####################

function gatherEC2Volume_Data([string]$outputDir, [string[]]$regions)
{
    $startTime = Get-Date

    "Start Time: " + $startTime

    ">>>>>>>>>> Gathering EC2VolumeInfo"

    foreach ($region in $Regions)
    {
        Set-Location $outputDir
        "    ---- Processing $region"
      
        getEC2VolumeInfo_FromRegion $region `
            > "EC2_VolumeInfo_$(getRegionAbbreviation $region).csv"
    }
       
    $endTime = Get-Date

    "Elapsed Time: " + ($endTime - $startTime | Select-Object Hours, Minutes, Seconds)
}

#endregion #################### EC2 Volume ####################

#region #################### EC2 InstanceType ####################

function gatherEC2_InstanceTypes([string]$outputDir, [string[]]$regions)
{
    $startTime = Get-Date

    "Start Time: " + $startTime

    ">>>>>>>>>> Gathering EC2_InstanceTypes"

    foreach ($region in $Regions)
    {
        Set-Location $outputDir
        "    ---- Processing $region"

        $header = "Region,InstanceType"
        $header += ",CurrentGeneration"
        $header += ",BareMetal"

        $header += ",SustainedClockSpeedGhz"
        $header += ",DefaultCores"
        $header += ",DefaultThreadsPerCore"
        $header += ",DefaultVCpus"
        $header += ",Memory (GB)"
        $header += ",BurstablePerformanceSupported"

        $header += ",EBS.EbsOptimizedSupport"
        $header += ",EBS.EncryptionSupport"
        $header += ",EBS.NvmeSupport"

        $header += ",InstanceStorageSupported"
        $header += ",IS.TotalSize (GB)"
        $header += ",IS.EncryptionSupport"
        $header += ",IS.NvmeSupport"    

        $header > "EC2_InstanceTypes_$($region).csv"

        getEC2InstanceTypes $region >> "EC2_InstanceTypes_$($region).csv"
    }

    $endTime = Get-Date

    "Elapsed Time: " + ($endTime - $startTime | Select-Object Hours, Minutes, Seconds)
}

#endregion #################### EC2 InstanceType ####################

#endregion #################### EC2 Data ####################

function gatherMonthlyEC2_Utilization_Data(
    [string]$outputDir,    
    [string[]]$regions, 
    [string]$yearMonth,
    [System.DateTime]$startTime, [System.DateTime]$endTime)
{
    $runStartTime = Get-Date
    
    ">>>>>>>>>> Gathering EC2 Utilization Data"

    foreach ($region in $Regions)
    {    
        Set-Location $outputDir

        gatherEC2UtilizationMetricsForRegion $outputDir $yearMonth $region $startTime $endTime
    }   

    $runEndTime = Get-Date

    "Elapsed Time: " + ($runEndTime - $runStartTime | Select-Object Hours, Minutes, Seconds)
}

function gatherMonthlyECS_Utilization_Data(
    [string]$outputDir,    
    [string[]]$regions, 
    [string]$yearMonth,
    [System.DateTime]$startTime, [System.DateTime]$endTime)
{
    Set-Location "$($outputDir)\Cluster_Service_Utilization"
    $outputDirYearMonth = "$($outputDir)\Cluster_Service_Utilization\$($yearMonth)"

    if (!(Test-Path -Path $yearMonth)) { New-Item -Name $yearMonth -ItemType Directory } 

    $runStartTime = Get-Date
    
    ">>>>>>>>>> Gathering ECS Utilization Data"

    foreach ($region in $Regions)
    {
        # if (!(Test-Path -Path $yearMonth)) { New-Item -Name $yearMonth -ItemType Directory }
    
        # $outputDirYearMonth = "$outputDir\$yearMonth"    
        
        Set-Location $outputDirYearMonth       
    
        if (!(Test-Path -Path $region)) { New-Item -Name $region -ItemType Directory }
    
        $regionOutputDirectory = "$outputDirYearMonth\$region"
    
        ">> Processing $region"
    
        $clusterArray = @(getClusters $region)
    
        foreach($cluster in $clusterArray)
        {
            Set-Location $regionOutputDirectory
    
            if (!(Test-Path -Path $cluster)) { New-Item -Name $cluster -ItemType Directory }
    
            $outputDirectory = "$regionOutputDirectory\$cluster"
    
            GetClusterUtilizationDataFiles $region $cluster $startTime $endTime $outputDirectory -IncludeCluster -IncludeService -GatherData
        }
    }

    $runEndTime = Get-Date

    "Elapsed Time: " + ($runEndTime - $runStartTime | Select-Object Hours, Minutes, Seconds)
}

################################################################################
#
# Gather_EC2Data_Functions.ps1
#
################################################################################