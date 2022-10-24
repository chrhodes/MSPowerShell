################################################################################
#
# Gather_ECSData_Functions.ps1
#
#
# NB. These functions do not check if the $outputDir exists.
# Handle in the caller
#
################################################################################

Set-StrictMode -Version Latest

#region #################### ECS Data ####################

#region #################### ECS Cluster ####################

function gatherECS_ClusterData([string]$outputDir, [string[]]$regions)
{
    $startTime = Get-Date

    "Start Time: " + $startTime

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

    "Elapsed Time: " + ($endTime - $startTime | Select-Object Hours, Minutes, Seconds)
}

#endregion #################### ECS Cluster ####################

#region #################### ECS Cluster Service ####################

function gatherECS_ServiceData([string]$outputDir, [string[]]$regions)
{
    $startTime = Get-Date

    "Start Time: " + $startTime

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

    "Elapsed Time: " + ($endTime - $startTime | Select-Object Hours, Minutes, Seconds)
}

#endregion #################### ECS Cluster Sevice ####################

#region #################### ECS Task Definition ####################

function gatherECS_TaskDefinitionData([string]$outputDir, [string[]]$regions)
{
    $startTime = Get-Date

    "Start Time: " + $startTime

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

    ">>>>>>>>>> Gathering ECS_TaskDefinitionContainerInfo"

    foreach ($region in $Regions)
    {
        Set-Location $outputDir
        "    ---- Processing $region"

        getECSTaskDefinitionContainerInfo_FromRegion $region `
            > "ECS_TaskDefContainerInfo_$(getRegionAbbreviation $region).csv"
    }    

    $endTime = Get-Date

    "Elapsed Time: " + ($endTime - $startTime | Select-Object Hours, Minutes, Seconds)
}

#endregion #################### ECS Task Definition Families ####################

#region #################### ECS Cluster Task ####################

function gatherECS_TaskData([string]$outputDir, [string[]]$regions)
{
    $startTime = Get-Date

    "Start Time: " + $startTime    

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

    "Elapsed Time: " + ($endTime - $startTime | Select-Object Hours, Minutes, Seconds)
}

#endregion #################### ECS Cluster Task ####################

#region #################### ECS Cluster Containers ####################

function gatherECS_ContainerInstanceData([string]$outputDir, [string[]]$regions)
{
    $startTime = Get-Date

    "Start Time: " + $startTime

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

    "Elapsed Time: " + ($endTime - $startTime | Select-Object Hours, Minutes, Seconds)
}

#endregion #################### ECS Cluster Containers ####################

#endregion #################### ECS Data ####################

################################################################################
#
# Gather_ECSData_Functions.ps1
#
################################################################################