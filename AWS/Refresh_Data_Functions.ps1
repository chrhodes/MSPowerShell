################################################################################
#
# Refresh_Data_Functions.ps1
#
################################################################################

Set-StrictMode -Version Latest

#region #################### ECS Cluster ####################

function refreshECS_ClusterData([string[]]$regions)
{
    $startTime = Get-Date

    ">>>>>>>>>> Gathering ECS_ClusterInfo"

    foreach ($region in $Regions)
    {
        Set-Location $outputDir
        "    ---- Processing $region"

        $clusters = @(getClusters $region)

        getECSClusterInfo_FromClusters $clusters $region `
            > "ECS_ClusterInfo_$(getRegionAbbreviation $region).csv"
    }

    ">>>>>>>>>> Gathering ECS_Tags_Cluster"

    foreach ($region in $Regions)
    {
        Set-Location $outputDir
        "    ---- Processing $region"

        $clusters = @(getClusters $region)

        getTags_FromClusters $clusters $region `
            > "ECS_Tags_Cluster_$(getRegionAbbreviation $region).csv"
    }

    ">>>>>>>>>> Gathering ECS_ClusterCapacityProviderInfo"

    foreach ($region in $Regions)
    {
        Set-Location $outputDir
        "    ---- Processing $region"

        $clusters = @(getClusters $region)

        getECSClusterCapacityProviderInfo_FromClusters $clusters $region `
            > "ECS_ClusterCapacityProviderInfo_$(getRegionAbbreviation $region).csv"
    }

    ">>>>>>>>>> Gathering ECS_ClusterDefaultCapacityProviderStrategyInfo"

    foreach ($region in $Regions)
    {
        Set-Location $outputDir
        "    ---- Processing $region"

        $clusters = @(getClusters $region)

        getECSClusterDefaultCapacityProviderStrategyInfo_FromClusters $clusters $region `
            > "ECS_ClusterDefaultCapacityProviderStrategyInfo_$(getRegionAbbreviation $region).csv"
    }

    $endTime = Get-Date

    "Elapsed Time: "
    $endTime - $startTime | Select-Object Hours, Minutes, Seconds
}

#endregion #################### ECS Cluster ####################

#region #################### ECS Cluster Service ####################

function refreshECS_ServiceData([string[]]$regions)
{
    $startTime = Get-Date

    ">>>>>>>>>> Gathering ECS_ServicesInfo"

    foreach ($region in $Regions)
    {
        Set-Location $outputDir
        "    ---- Processing $region"
       
        $clusters = @(getClusters $region)
        getECSClusterServicesInfo_FromClusters $clusters $region `
            > "ECS_ServicesInfo_$(getRegionAbbreviation $region).csv"
    }
    
    ">>>>>>>>>> Gathering ECS_Tags_Service"

    foreach ($region in $Regions)
    {
        Set-Location $outputDir
        "    ---- Processing $region"
        
        $clusters = @(getClusters $region)
    
        getServicesTags_FromClusters $clusters $region `
            > "ECS_Tags_Service_$(getRegionAbbreviation $region).csv"
    }

    $endTime = Get-Date

    "Elapsed Time: "
    $endTime - $startTime | Select-Object Hours, Minutes, Seconds
}

#endregion #################### ECS Cluster Sevice ####################

#region #################### ECS Task Definition ####################
function refreshECS_TaskDefinitionData([string[]]$regions)
{
    $startTime = Get-Date

    ">>>>>>>>>> Gathering ECS_TaskDefinitionFamilies"

    foreach ($region in $Regions)
    {
        Set-Location $outputDir
        "    ---- Processing $region"

        $header = "Region, TaskDefinitionFamily"

        $header > "ECS_TaskDefinitionFamilies_$(getRegionAbbreviation $region).csv"

        getECSTaskDefinitionFamilyList $region `
            >> "ECS_TaskDefinitionFamilies_$(getRegionAbbreviation $region).csv"
    }

    ">>>>>>>>>> Gathering ECS_TaskDefinition"

    foreach ($region in $Regions)
    {
        Set-Location $outputDir
        "    ---- Processing $region"

        $header = "Region, TaskDefinitionArn"

        $header > "ECS_TaskDefinition_$(getRegionAbbreviation $region).csv"

        getECSTaskDefinitionList $region `
            >> "ECS_TaskDefinition_$(getRegionAbbreviation $region).csv"
    }

    ">>>>>>>>>> Gathering ECS_TaskDefinitionInfo"

    foreach ($region in $Regions)
    {
        Set-Location $outputDir
        "    ---- Processing $region"

        getECSTaskDefinitionInfo_FromRegion $region `
            > "ECS_TaskDefinitionInfo_$(getRegionAbbreviation $region).csv"
    }

    $endTime = Get-Date

    "Elapsed Time: "
    $endTime - $startTime | Select-Object Hours, Minutes, Seconds
}

#endregion #################### ECS Task Definition Families ####################

#region #################### ECS Cluster Task ####################
function refreshECS_TaskData([string[]]$regions)
{
    $startTime = Get-Date

    ">>>>>>>>>> Gathering ECS_TaskInfo"

    foreach ($region in $Regions)
    {
        Set-Location $outputDir
        "    ---- Processing $region"

        $clusters = @(getClusters $region)

        getECSTaskInfo_FromClusters $clusters $region `
            > "ECS_TaskInfo_$(getRegionAbbreviation $region).csv"
    }

    ">>>>>>>>>> Gathering ECS_Tags_Task"

    foreach ($region in $Regions)
    {
        Set-Location $outputDir
        "    ---- Processing $region"
    
        # $taskDefinitions = @(getECSTaskDefinitionList $region)
        $clusters = @(getClusters $region)
    
        getTasksTags_FromClusters $clusters $region `
            > "ECS_Tags_Task_$(getRegionAbbreviation $region).csv"
    }    

    # TODO(crhodes)
    # This has problems.  Investigate.  Skip for now.

    # # getECSTaskContainerInfo_FromClusters $ClusterArray > ECSClusters_ECSTaskContainerInfo.csv

    # foreach ($region in $Regions)
    # {
    #     Set-Location $outputDir
    #     "    ---- Processing $region ----------"

    #     $clusters = @(getClusters $region)

    #     getECSTaskContainerInfo_FromClusters $clusters $region > "ECS_TaskContainerInfo_$(getRegionAbbreviation $region).csv"
    # }

    # Doesn't seem like any Tasks have Tags.  Get someone to add a Tag so can test code

    # foreach ($region in $Regions)
    # {
    #     Set-Location $outputDir
    #     "    ---- Processing $region ----------"

    #     $clusters = @(getClusters $region)

    #     getTasksTags_FromClusters $clusters $region > "ECS_Tags_Task_$(getRegionAbbreviation $region).csv"
    # }

    $endTime = Get-Date

    "Elapsed Time: "
    $endTime - $startTime | Select-Object Hours, Minutes, Seconds
}

#endregion #################### ECS Cluster Task ####################

#region #################### ECS Cluster Containers ####################

function refreshECS_ContainerInstanceData([string[]]$regions)
{
    $startTime = Get-Date

    ">>>>>>>>>> Gathering ECS_ContainerInstanceInfo"

    foreach ($region in $Regions)
    {
        Set-Location $outputDir
        "    ---- Processing $region"

        $clusters = @(getClusters $region)

        getECSContainerInstanceInfo_FromClusters $clusters $region `
            > "ECS_ContainerInstanceInfo_$(getRegionAbbreviation $region).csv"
    }

    $endTime = Get-Date

    "Elapsed Time: "
    $endTime - $startTime | Select-Object Hours, Minutes, Seconds
}

#endregion #################### ECS Cluster Containers ####################

#region #################### ECS EC2 Instance ####################

function refreshEC2_Data([string[]]$regions)
{
    $startTime = Get-Date

    # "---------- Gathering ECS_ContainerEC2InstanceInfo for $region ----------"

    # foreach ($region in $Regions)
    # {
    #     Set-Location $outputDir
    #     "    ---- Processing $region ----------"

    #     $clusters = @(getClusters $region)

    #     getECSContainerEC2InstanceInfo_FromClusters $clusters $region `
    #         > "ECS_ContainerEC2InstanceInfo_$($region).csv"
    # }

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

    "Elapsed Time: "
    $endTime - $startTime | Select-Object Hours, Minutes, Seconds
}

function refreshEC2Volume_Data([string[]]$regions)
{
    $startTime = Get-Date

    ">>>>>>>>>> Gathering EC2VolumeInfo"

    foreach ($region in $Regions)
    {
        Set-Location $outputDir
        "    ---- Processing $region"
      
        getEC2VolumeInfo_FromRegion $region `
            > "EC2_VolumeInfo_$(getRegionAbbreviation $region).csv"
    }
    
    # ">>>>>>>>>> Gathering EC2_Tags_Instance"

    # foreach ($region in $Regions)
    # {
    #     Set-Location $outputDir
    #     "    ---- Processing $region"
    
    #     $instances = @(getEC2Instances $region)
    
    #     getTags_FromEC2Instances $instances $region `
    #         > "EC2_Tags_Instance_$(getRegionAbbreviation $region).csv"
    # }   
    
    $endTime = Get-Date

    "Elapsed Time: "
    $endTime - $startTime | Select-Object Hours, Minutes, Seconds
}

#endregion #################### ECS EC2 Instance ####################

#region #################### EC2 InstanceType ####################

function refreshEC2_InstanceTypes([string[]]$regions)
{
    $startTime = Get-Date

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

    "Elapsed Time: "
    $endTime - $startTime | Select-Object Hours, Minutes, Seconds
}

#endregion #################### EC2 InstanceType ####################

#region #################### AS AutoScalingGroup ####################

function refreshAS_Data([string[]]$Regions)
{
    $startTime = Get-Date

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

    "Elapsed Time: "
    $endTime - $startTime | Select-Object Hours, Minutes, Seconds
}

#endregion #################### AS AutoScalingGroup ####################

################################################################################
#
# Refresh_Data_Functions.ps1
#
################################################################################