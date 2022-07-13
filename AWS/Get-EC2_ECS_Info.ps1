################################################################################
#
# Get-EC2_ECS_Info.ps1
#
################################################################################

Set-StrictMode -Version Latest
#region #################### Intialization and Setup ####################
# Go play somewhere
#

$outputDir = "C:\Users\crhodes\My Drive\Budget & Costs\CSV Files"
Set-Location $outputDir

$codeOutputDir = "C:\VNC\git\chrhodes\MSPowerShell\AWS"
Set-Location $codeOutputDir

#
# If in VS Code, import module
#

Import-Module AWSPowerShell.NetCore

#
# Specify the profile to use
#

Set-AWSCredential -ProfileName PlatformCostsRO

#endregion Intialization and Setup

#region #################### Command Context ####################

$Regions = @("us-west-2", "us-east-2", "eu-west-1", "eu-central-1")
$Regions = @("us-east-2", "eu-west-1")
$region = $Regions[0]

# This is for developing and testing

# us-west-2
$ClusterArray = @("noae-sbx01", "daco-prod02")
# us-east-2
$ClusterArray = @("zsystemcm-cnc00", "kewtest2-cnc02")

$cluster = $ClusterArray[0]

# This is for full run against all clusters

$ClusterArray = @(getClusters "us-west-2")
$ClusterArray = @(getClusters "us-east-2")
$ClusterArray = @(getClusters "eu-west-1")
$ClusterArray = @(getClusters "eu-central-1")

#endregion Commnand Context

#region #################### Big Refresh Data Loop ####################

$Regions = @("us-west-2", "us-east-2", "eu-west-1", "eu-central-1")

refreshEC2_Data $regions

refreshECS_ClusterData $regions

refreshECS_ServiceData $regions

refreshECS_TaskData $regions

refreshECS_ContainerInstanceData $regions

refreshECS_TaskDefinitionData $regions

#endregion

#region #################### ECS Cluster ####################

# getECSClusterInfo $ClusterArray[0] $Regions[0]
# getECSClusterInfo_FromClusters $ClusterArray $Regions[0]

# getECSClusterCapacityProviderInfo_FromClusters $ClusterArray $Regions[0]

# getECSClusterDefaultCapacityProviderStrategyInfo_FromClusters $ClusterArray $Regions[0]

# $cluster = "daco-prod02"
# $cls = Get-ECSClusterDetail -Cluster $cluster -Region $region 
# | Select-Object -Expand Clusters
# $cls | Get-Member
# $cls.DefaultCapacityProviderStrategy.Count
# $cls.CapacityProviders.Count
# $cls.DefaultCapacityProviderStrategy.Count
# $cls.ClusterName

# $defaultCapacityProviderStrategy = $cls | Select-Object -ExpandProperty DefaultCapacityProviderStrategy
    
# $cls.DefaultCapacityProviderStrategy | Get-Member

foreach ($region in $Regions)
{
    $region
    "---------- $region begin ----------"
}

function refreshECS_ClusterData([string[]]$regions)
{
    ">>>>>>>>>> Gathering ECS_ClusterInfo <<<<<<<<<<"

    foreach ($region in $Regions)
    {
        Set-Location $outputDir
        "---------- Processing $region ----------"

        $clusters = @(getClusters $region)

        getECSClusterInfo_FromClusters $clusters $region `
            > "ECS_ClusterInfo_$(getRegionAbbreviation $region).csv"
    }

    ">>>>>>>>>> Gathering ECS_Tags_Cluster <<<<<<<<<<"

    foreach ($region in $Regions)
    {
        Set-Location $outputDir
        "---------- Processing $region ----------"

        $clusters = @(getClusters $region)

        getTags_FromClusters $clusters $region `
            > "ECS_Tags_Cluster_$(getRegionAbbreviation $region).csv"
    }

    ">>>>>>>>>> Gathering ECS_ClusterCapacityProviderInfo <<<<<<<<<<"

    foreach ($region in $Regions)
    {
        Set-Location $outputDir
        "---------- Processing $region ----------"

        $clusters = @(getClusters $region)

        getECSClusterCapacityProviderInfo_FromClusters $clusters $region `
            > "ECS_ClusterCapacityProviderInfo_$(getRegionAbbreviation $region).csv"
    }

    ">>>>>>>>>> Gathering ECS_ClusterDefaultCapacityProviderStrategyInfo <<<<<<<<<<"

    foreach ($region in $Regions)
    {
        Set-Location $outputDir
        "---------- Processing $region ----------"

        $clusters = @(getClusters $region)

        getECSClusterDefaultCapacityProviderStrategyInfo_FromClusters $clusters $region `
            > "ECS_ClusterDefaultCapacityProviderStrategyInfo_$(getRegionAbbreviation $region).csv"
    }
}

#region ECS Tags

# TODO(crhodes)
#   Not having much luck here
#   Get-ECSTagsForResource says it takes an Arn

$clusterArn = Get-ECSClusterDetail -Cluster $ClusterArray[0] | Select-Object -Expand Clusters | Select-Object ClusterArn

Get-ECSTagsForResource -ResourceArn $clusterArn

#endregion ECS Tags

#endregion #################### ECS Cluster ####################

#region #################### ECS Cluster Service ####################

# $cluster = $ClusterArray[0]
# $region = $Regions[0]
# $service = "arn:aws:ecs:us-west-2:049751716774:service/noae-sbx01/notification"

# getECSClusterServices $ClusterArray[0] $Regions[0]
# getECSClusterServices_FromClusters $ClusterArray $Regions[0]

# getECSClusterServicesInfo $ClusterArray[0] $Regions[0]
# getECSClusterServicesInfo_FromClusters $ClusterArray $Regions[0]

function refreshECS_ServiceData([string[]]$regions)
{
    ">>>>>>>>>> Gathering ECS_ServicesInfo <<<<<<<<<<"

    foreach ($region in $Regions)
    {
        Set-Location $outputDir
        "---------- Processing $region ----------"
       
        $clusters = @(getClusters $region)
        getECSClusterServicesInfo_FromClusters $clusters $region `
            > "ECS_ServicesInfo_$(getRegionAbbreviation $region).csv"
    }
    
    ">>>>>>>>>> Gathering ECS_Tags_Service <<<<<<<<<<"

    foreach ($region in $Regions)
    {
        Set-Location $outputDir
        "---------- Processing $region ----------"
        
        $clusters = @(getClusters $region)
    
        getServicesTags_FromClusters $clusters $region `
            > "ECS_Tags_Service_$(getRegionAbbreviation $region).csv"
    }
}

#endregion #################### ECS Cluster Sevice ####################

#region #################### ECS Task Definition Families ####################

function refreshECS_TaskDefinitionData([string[]]$regions)
{
    ">>>>>>>>>> Gathering ECS_TaskDefinitionFamilies <<<<<<<<<<"

    foreach ($region in $Regions)
    {
        Set-Location $outputDir
        "---------- Processing $region ----------"

        $header = "Region, TaskDefinitionFamily"

        $header > "ECS_TaskDefinitionFamilies_$(getRegionAbbreviation $region).csv"

        getECSTaskDefinitionFamilyList $region `
            >> "ECS_TaskDefinitionFamilies_$(getRegionAbbreviation $region).csv"
    }

    ">>>>>>>>>> Gathering ECS_TaskDefinition <<<<<<<<<<"

    foreach ($region in $Regions)
    {
        Set-Location $outputDir
        "---------- Processing $region ----------"

        $header = "Region, TaskDefinitionArn"

        $header > "ECS_TaskDefinition_$(getRegionAbbreviation $region).csv"

        getECSTaskDefinitionList $region `
            >> "ECS_TaskDefinition_$(getRegionAbbreviation $region).csv"
    }
}

#endregion #################### ECS Task Definition Families ####################

#region #################### ECS Cluster Task ####################

$cluster = $ClusterArray[0]
$region = $Regions[0]
$taskArn = "arn:aws:ecs:us-west-2:049751716774:task/noae-sbx01/00b559e2e6e943b8a14726084a172043"
$task = getTaskName($taskArn) 
getECSTasks $ClusterArray[0] $Regions[0]
getECSTasks_FromClusters $ClusterArray $Regions[0]

getECSTaskInfo $ClusterArray[0] $Regions[0]
getECSTaskInfo_FromClusters $ClusterArray $Regions[0]

function refreshECS_TaskData([string[]]$regions)
{
    ">>>>>>>>>> Gathering ECS_TaskInfo <<<<<<<<<<"

    foreach ($region in $Regions)
    {
        Set-Location $outputDir
        "---------- Processing $region ----------"

        $clusters = @(getClusters $region)

        getECSTaskInfo_FromClusters $clusters $region `
            > "ECS_TaskInfo_$(getRegionAbbreviation $region).csv"
    }

    ">>>>>>>>>> Gathering ECS_Tags_Task <<<<<<<<<<"

    foreach ($region in $Regions)
    {
        Set-Location $outputDir
        "---------- Processing $region ----------"
    
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
    #     "---------- Processing $region ----------"

    #     $clusters = @(getClusters $region)

    #     getECSTaskContainerInfo_FromClusters $clusters $region > "ECS_TaskContainerInfo_$(getRegionAbbreviation $region).csv"
    # }

    # Doesn't seem like any Tasks have Tags.  Get someone to add a Tag so can test code

    # foreach ($region in $Regions)
    # {
    #     Set-Location $outputDir
    #     "---------- Processing $region ----------"

    #     $clusters = @(getClusters $region)

    #     getTasksTags_FromClusters $clusters $region > "ECS_Tags_Task_$(getRegionAbbreviation $region).csv"
    # }
}

# getECSTaskInfo_FromClusters $ClusterArray > ECSCLusters_ECSTaskInfo.csv

# getECSTaskContainerInfo $ClusterArray[0] $Regions[0]
# getECSTaskContainerInfo_FromClusters $ClusterArray $Regions[0]




# TODO(crhodes)
# Get a task that matches other examples

$taskDefinitionArn = "arn:aws:ecs:us-west-2:049751716774:task-definition/api-event:4"
get

getECSTaskDefinitionInfo $taskDefinition $region


#endregion #################### ECS Cluster Task ####################

#region #################### ECS Cluster Containers ####################

# $cluster = $ClusterArray[0]
# $region = $Regions[0]
# $containerInstance = "arn:aws:ecs:us-west-2:049751716774:container-instance/noae-sbx01/84de27e814cd4ae39af06ed15965bf00"

# $ci = Get-ECSContainerInstanceDetail -Region $region $cluster -ContainerInstance $containerInstance 
# | Get-Member

# $ciCntr = Get-ECSContainerInstanceDetail -Region $region $cluster -ContainerInstance $containerInstance | 
# Select-Object -Expand ContainerInstances
# $ciCntr | Get-Member

# getECSContainerInstances $ClusterArray[0] $Regions[0]
# getECSContainerInstances_FromClusters $ClusterArray $Regions[0]

# getECSContainerInstanceInfo $ClusterArray[0] $Regions[0]
# getECSContainerInstanceInfo_FromClusters $ClusterArray $Regions[0]

function refreshECS_ContainerInstanceData([string[]]$regions)
{
    ">>>>>>>>>> Gathering ECS_ContainerInstanceInfo <<<<<<<<<<"

    foreach ($region in $Regions)
    {
        Set-Location $outputDir
        "---------- Processing $region ----------"

        $clusters = @(getClusters $region)

        getECSContainerInstanceInfo_FromClusters $clusters $region `
            > "ECS_ContainerInstanceInfo_$(getRegionAbbreviation $region).csv"
    }
}

#endregion #################### ECS Cluster Containers ####################

#region #################### ECS EC2 Instance ####################

# NOTE(crhodes)
# Decide if we need this now that doing more work in PowerQuery
# getEC2Instances $ClusterArray[0] $Regions[0]
# getEC2Instances_FromClusters $ClusterArray $Regions[0]


# foreach ($region in $Regions)
# {
#     Set-Location $outputDir
#     "---------- Processing $region ----------"

#     $clusters = @(getClusters $region)

#     getEC2Instances_FromClusters $clusters $region > "ECS_EC2Instances_$(getRegionAbbreviation $region).csv"
# }

# getECSContainerEC2InstanceInfo $ClusterArray[0] $Regions[0]
# getECSContainerEC2InstanceInfo_FromClusters $ClusterArray $Regions[0]

function refreshEC2_Data([string[]]$regions)
{
    # "---------- Gathering ECS_ContainerEC2InstanceInfo for $region ----------"

    # foreach ($region in $Regions)
    # {
    #     Set-Location $outputDir
    #     "---------- Processing $region ----------"

    #     $clusters = @(getClusters $region)

    #     getECSContainerEC2InstanceInfo_FromClusters $clusters $region `
    #         > "ECS_ContainerEC2InstanceInfo_$($region).csv"
    # }

    ">>>>>>>>>> Gathering EC2_InstanceInfo <<<<<<<<<<"

    foreach ($region in $Regions)
    {
        Set-Location $outputDir
        "---------- Processing $region ----------"
    
        $instances = @(getEC2Instances $region)
    
        getEC2InstanceInfo_FromInstances $instances $region `
            > "EC2_InstanceInfo_$(getRegionAbbreviation $region).csv"
    }
    
    ">>>>>>>>>> Gathering EC2_Tags_Instance <<<<<<<<<<"

    foreach ($region in $Regions)
    {
        Set-Location $outputDir
        "---------- Processing $region ----------"
    
        $instances = @(getEC2Instances $region)
    
        getTags_FromEC2Instances $instances $region `
            > "EC2_Tags_Instance_$(getRegionAbbreviation $region).csv"
    }    
}

#endregion #################### ECS EC2 Instance ####################

#region #################### EC2 InstanceType ####################

# $InstanceArray = @(getEC2Instances "eu-west-1")
# $InstanceArray = @(getEC2Instances "eu-central-1")
# $InstanceArray = @(getEC2Instances "us-east-2")
# $InstanceArray = @(getEC2Instances "us-west-2")

# $ec2Instance = "i-019eff05b5bc0c82a"
# getEC2InstanceInfo $ec2Instance "us-east-2"

# $Regions = @("us-west-2", "us-east-2", "eu-west-1", "eu-central-1")
# $Regions = @("us-east-2", "eu-west-1")

# foreach ($region in $Regions)
# {
#     Set-Location $outputDir
#     "---------- Processing $region ----------"

#     $instances = @(getEC2Instances $region)

#     getEC2InstanceInfo_FromInstances $instances $region > "EC2_InstanceInfo_$(getRegionAbbreviation $region).csv"
# }

# $region = "us-west-2"
# $testInstances = @($instances[0..5])
# getTags_FromEC2Instances $testInstances $region

# foreach ($region in $Regions)
# {
#     Set-Location $outputDir
#     "---------- Processing $region ----------"

#     $instances = @(getEC2Instances $region)

#     getTags_FromEC2Instances $instances $region > "EC2_Tags_Instance_$(getRegionAbbreviation $region).csv"
# }

# NOTE(crhodes)
# Only need to run this if InstanceTypes change

$json = Get-EC2InstanceType -Region $Regions[0] -InstanceType "m1.large" | ConvertTo-Json -Depth 10
getEC2InstanceTypes $Regions[0]

">>>>>>>>>> Gathering EC2_InstanceTypes <<<<<<<<<<"

foreach ($region in $Regions)
{
    Set-Location $outputDir
    "---------- Processing $region ----------"

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

#endregion #################### EC2 InstanceType ####################

#region #################### EC2 Utilization ####################

# Utilization

$region = "us-west-2"

$ec2InstanceId = "i-57542c92"
getEC2InstanceInfo $ec2InstanceId $region

$startTime.ToUniversalTime()
$endTime.ToUniversalTime()

getCW_EC2_CPUUtilization $ec2InstanceId $region $startTime $endTime

foreach ($region in $Regions)
{
    $startTime = Get-Date -Date "2022-06-01 00:00:00Z"
    $endTime = Get-Date -Date "2022-06-30 23:59:59Z"

    Set-Location "$outputDir\EC2 CPU Utilization 2022.06\"
    "---------- Processing $region ----------"

    $instances = @(getEC2Instances $region)

    foreach($ec2InstanceId in $instances)
    {
        $outputFile = "CPU_$($ec2InstanceId)_$($region).csv"

        # Don't need to add this as all data can be pulled using
        # VLOOKUP to EC2 workbook
        # getEC2InstanceInfo $ec2Instance $region > $outputFile

        $header = "Region,EC2InstanceId,TimeStamp,Minimum,Average,Maximum"
        $header > $outputFile

        "Gathering CPU Utilization for $region $ec2InstanceId"

        getCW_EC2_CPUUtilization $ec2InstanceId $region $startTime $endTime `
            >> $outputFile
            # ConvertTo-Csv >> "CPU_$($ec2InstanceId)_$($region).csv"
    }
}

$outputDir = "C:\Users\crhodes\My Drive\Budget & Costs\CSV Files\CPU Utilization Explore"
Set-Location $outputDir

$startTime = Get-Date -Date "2022-07-01 00:00:00Z"
$endTime = Get-Date -Date "2022-07-12 23:59:59Z"

$region = "us-west-2"

$ec2InstanceId = "i-0f65358267fb8074d"

$outputFile = "$($ec2InstanceId)_$(getRegionAbbreviation $region).csv"

$header = "Region,EC2InstanceId,TimeStamp,Minimum,Average,Maximum"
$header > $outputFile

$ec2InstanceId
$region
$startTime
$endTime

getCW_EC2_CPUUtilization $ec2InstanceId $region $startTime $endTime >> $outputFile

$outputDir = "C:\Users\crhodes\My Drive\Budget & Costs\CSV Files"
Set-Location $outputDir

$startTime = Get-Date -Date "2022-07-01 00:00:00Z"
$endTime = Get-Date -Date "2022-07-12 23:59:59Z"

$region = "us-west-2"
$cluster = "noae-sbx01"

GetClusterDataFiles $region $cluster $startTime $endTime

$clusters = @(getClusters $region)

$Regions = @("us-west-2", "us-east-2", "eu-west-1", "eu-central-1")

foreach ($region in $Regions)
{
    $startTime = Get-Date -Date "2022-06-01 00:00:00Z"
    $endTime = Get-Date -Date "2022-06-30 23:59:59Z"

    # $startTime = Get-Date -Date "2022-07-01 00:00:00Z"
    # $endTime = Get-Date -Date "2022-07-12 23:59:59Z"

    $outputDirectory = "$outputDir\Cluster_Service_Utilization\"
    "---------- Processing $region ----------"

    $vbaCommands = "EXCEL_VBA_$($region).txt"

    "Processing Region $region" > $vbaCommands

    $clusterArray = @(getClusters $region)

    foreach($cluster in $clusterArray)
    {
        GetClusterDataFiles  $region $cluster $startTime $endTime $outputDirectory $vbaCommands
    }
}

function GetClusterDataFiles($region, [String]$cluster, $startTime, $endTime, $outputDir, $vbaCommands)
{
    Set-Location $outputDir

    # "---------- Processing Cluster $cluster in $region ----------"

    # "' Gather Utilization data for Cluster" >> $vbaCommands

    # $outputFile = "C-$($cluster)_$(getRegionAbbreviation $region).csv" 

    # $header = "Region,Cluster,TimeStamp,Minimum,Average,Maximum"
    # $header > $outputFile
    # getCW_ECS_Cluster_CPUUtilization $cluster $region $startTime $endTime >> $outputFile

    # "" >> $vbaCommands
    # "    AddCPUUtilizationWorksheet reportName, ""$outputFile""" >> $vbaCommands

    "---------- Processing Services for $cluster $region ---------- "

    "" >> $vbaCommands
    "' Gather Utilization data for Services in Cluster" >> $vbaCommands
    "" >> $vbaCommands

    foreach($serviceArn in (getECSClusterServices $cluster $region))
    {
        $service = getServiceName($serviceArn)

        $csi = Get-ECSService -Cluster $cluster -Service $service -Region $region |
            Select-Object -Expand Services

        $serviceName = $csi.ServiceName

        $outputFile = "S-$($serviceName)_$(getRegionAbbreviation $region).csv"
  
        "---------- Processing $cluster $serviceName $region ----------"

        $header = "Region,Service,TimeStamp,Minimum,Average,Maximum"
        $header > $outputFile        

        getCW_ECS_Service_CPUUtilization $cluster $serviceName $region $startTime $endTime >> $outputFile
        
        "    AddCPUUtilizationWorksheet reportName, ""$outputFile""" >> $vbaCommands
    }

    # "---------- Processing ContainerInstances for $cluster $region ---------- "

    # "" >> $vbaCommands
    # "' Gather Utilization data for ContainerInstances(Ec2Instance) in Cluster" >> $vbaCommands
    # "" >> $vbaCommands

    # foreach($containerInstanceArn in (getECSContainerInstances $cluster $region))
    # {
    #     $clsn = getContainerInstanceName $containerInstanceArn

    #     $cntr = Get-ECSContainerInstanceDetail -Cluster $cluster -ContainerInstance $clsn -Region $region | 
    #     Select-Object -ExpandProperty ContainerInstances

    #     $ec2InstanceId = $cntr.Ec2InstanceId

    #     $outputFile = "E-$($ec2InstanceId)_$(getRegionAbbreviation $region).csv"

    #     $header = "Region,EC2InstanceId,TimeStamp,Minimum,Average,Maximum"
    #     $header > $outputFile

    # "---------- Processing $ec2InstanceId $region ----------"

    #     getCW_EC2_CPUUtilization $ec2InstanceId $region $startTime $endTime >> $outputFile

    #     "    AddCPUUtilizationWorksheet reportName, ""$outputFile""" >> $vbaCommands        
    # }
}


$cluster
$region
$startTime
$endTime

$outputFile = "$($cluster)_$($region).csv"

$header = "Region,Cluster,TimeStamp,Minimum,Average,Maximum"
$header > $outputFile

getCW_ECS_Cluster_CPUUtilization $cluster $region $startTime $endTime >> $outputFile


$cluster = "noae-sbx01"



$service = "notification"

$cluster
$service
$region
$startTime
$endTime

$outputFile = "$($cluster)_$($service)_$(getRegionAbbreviation $region).csv"

$header = "Region,Service,TimeStamp,Minimum,Average,Maximum"
$header > $outputFile

getCW_ECS_Service_CPUUtilization $cluster $service $region $startTime $endTime >> $outputFile


#endregion #################### EC2 Utilization ####################

#region #################### AS AutoScalingGroup ####################

$region = "us-west-2"
$asGroup = "zin-prod-asg"
$asInstance = "i-04be99315aebb9dd3"

getAutoScalingGroupInfo $asGroup $region

">>>>>>>>>> Gathering AS_AutoScaling_Groups <<<<<<<<<<"

foreach ($region in $Regions)
{
    Set-Location $outputDir
    "---------- Processing $region ----------"

    $asGroups = @(getAutoScalingGroups $region)
    
    getAutoScalingGroupInfo_FromInstances $asGroups $region  `
        > "AS_AutoScaling_Groups_$(getRegionAbbreviation $region).csv"
}

Get-ASAutoScalingInstance -InstanceId $asGroup -Region $region
Get-ASAutoScalingInstance -InstanceId $asInstance -Region $region

$asInstances = $asInstances[0..5]
getASAutoScalingInstanceInfo_FromInstances $asInstances $region

getASAutoScalingInstanceInfo $asInstance $region

">>>>>>>>>> Gathering AS_AutoScaling_Instances <<<<<<<<<<"

foreach ($region in $Regions)
{
    Set-Location $outputDir
    "---------- Processing $region ----------"

    $asInstances = @(getAutoScalingInstances $region)
    
    getASAutoScalingInstanceInfo_FromInstances $asInstances $region  `
        > "AS_AutoScaling_Instances_$(getRegionAbbreviation $region).csv"
}

#endregion #################### AS AutoScalingGroup ####################

################################################################################
#
# Get-EC2_ECS_Info.ps1
#
################################################################################