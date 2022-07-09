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

#region #################### ECS Cluster ####################

getECSClusterInfo $ClusterArray[0] $Regions[0]
getECSClusterInfo_FromClusters $ClusterArray $Regions[0]

getECSClusterCapacityProviderInfo_FromClusters $ClusterArray $Regions[0]

getECSClusterDefaultCapacityProviderStrategyInfo_FromClusters $ClusterArray $Regions[0]

$cluster = "daco-prod02"
$cls = Get-ECSClusterDetail -Cluster $cluster -Region $region 
| Select-Object -Expand Clusters
$cls | Get-Member
$cls.DefaultCapacityProviderStrategy.Count
$cls.CapacityProviders.Count
$cls.DefaultCapacityProviderStrategy.Count
$cls.ClusterName

$defaultCapacityProviderStrategy = $cls | Select-Object -ExpandProperty DefaultCapacityProviderStrategy
    
$cls.DefaultCapacityProviderStrategy | Get-Member

foreach ($region in $Regions)
{
    $region
    "---------- $region begin ----------"
}

foreach ($region in $Regions)
{
    Set-Location $outputDir
    "---------- Processing $region ----------"

    $clusters = @(getClusters $region)

    getECSClusterInfo_FromClusters $clusters $region > "ECS_ClusterInfo_$($region).csv"
}

foreach ($region in $Regions)
{
    Set-Location $outputDir
    "---------- Processing $region ----------"

    $clusters = @(getClusters $region)

    getTags_FromClusters $clusters $region > "ECS_Tags_Cluster_$($region).csv"
}

foreach ($region in $Regions)
{
    Set-Location $outputDir
    "---------- Processing $region ----------"

    $clusters = @(getClusters $region)

    getECSClusterCapacityProviderInfo_FromClusters $clusters $region `
        > "ECS_ClusterCapacityProviderInfo_$($region).csv"
}

foreach ($region in $Regions)
{
    Set-Location $outputDir
    "---------- Processing $region ----------"

    $clusters = @(getClusters $region)

    getECSClusterDefaultCapacityProviderStrategyInfo_FromClusters $clusters $region `
        > "ECS_ClusterDefaultCapacityProviderStrategyInfo_$($region).csv"
}

#region ECS Tags

# TODO(crhodes)
#   Not having much luck here
#   Get-ECSTagsForResource says it takes an Arn

$clusterArn = Get-ECSClusterDetail -Cluster $ClusterArray[0] | Select-Object -Expand Clusters | Select-Object ClusterArn

Get-ECSTagsForResource -ResourceArn $clusterArn

#endregion ECS Tags

#endregion ECS Cluster

#region #################### ECS Cluster Service ####################

$cluster = $ClusterArray[0]
$region = $Regions[0]
$service = "arn:aws:ecs:us-west-2:049751716774:service/noae-sbx01/notification"

getECSClusterServices $ClusterArray[0] $Regions[0]
getECSClusterServices_FromClusters $ClusterArray $Regions[0]

getECSClusterServicesInfo $ClusterArray[0] $Regions[0]
getECSClusterServicesInfo_FromClusters $ClusterArray $Regions[0]

foreach ($region in $Regions)
{
    Set-Location $outputDir
    "---------- Processing $region ----------"
   
    $clusters = @(getClusters $region)
    getECSClusterServicesInfo_FromClusters $clusters $region > "ECS_ServicesInfo_$($region).csv"
}

foreach ($region in $Regions)
{
    Set-Location $outputDir
    "---------- Processing $region ----------"
    
    $clusters = @(getClusters $region)

    getServicesTags_FromClusters $clusters $region > "ECS_Tags_Service_$($region).csv"
}

#endregion ECS Cluster Sevice

#region #################### ECS Task Definition Families ####################

foreach ($region in $Regions)
{
    Set-Location $outputDir
    "---------- Processing $region ----------"

    $header = "Region, TaskDefinitionFamily"

    $header > "ECS_TaskDefinitionFamilies_$($region).csv"

    getECSTaskDefinitionFamilyList $region >> "ECS_TaskDefinitionFamilies_$($region).csv"
}

foreach ($region in $Regions)
{
    Set-Location $outputDir
    "---------- Processing $region ----------"

    $header = "Region, TaskDefinitionArn"

    $header > "ECS_TaskDefinition_$($region).csv"

    getECSTaskDefinitionList $region >> "ECS_TaskDefinition_$($region).csv"
}

#endregion

#region #################### ECS Cluster Task ####################

$cluster = $ClusterArray[0]
$region = $Regions[0]
$taskArn = "arn:aws:ecs:us-west-2:049751716774:task/noae-sbx01/00b559e2e6e943b8a14726084a172043"
$task = getTaskName($taskArn) 
getECSTasks $ClusterArray[0] $Regions[0]
getECSTasks_FromClusters $ClusterArray $Regions[0]

getECSTaskInfo $ClusterArray[0] $Regions[0]
getECSTaskInfo_FromClusters $ClusterArray $Regions[0]

foreach ($region in $Regions)
{
    Set-Location $outputDir
    "---------- Processing $region ----------"

    $clusters = @(getClusters $region)

    getECSTaskInfo_FromClusters $clusters $region > "ECS_TaskInfo_$($region).csv"
}

# getECSTaskInfo_FromClusters $ClusterArray > ECSCLusters_ECSTaskInfo.csv

getECSTaskContainerInfo $ClusterArray[0] $Regions[0]
getECSTaskContainerInfo_FromClusters $ClusterArray $Regions[0]

# TODO(crhodes)
# This has problems.  Investigate.  Skip for now.

foreach ($region in $Regions)
{
    Set-Location $outputDir
    "---------- Processing $region ----------"

    $clusters = @(getClusters $region)

    getECSTaskContainerInfo_FromClusters $clusters $region > "ECS_TaskContainerInfo_$($region).csv"
}

# getECSTaskContainerInfo_FromClusters $ClusterArray > ECSClusters_ECSTaskContainerInfo.csv

# Doesn't seem like any Tasks have Tags.  Get someone to add a Tag so can test code

foreach ($region in $Regions)
{
    Set-Location $outputDir
    "---------- Processing $region ----------"

    $clusters = @(getClusters $region)

    getTasksTags_FromClusters $clusters $region > "ECS_Tags_Task_$($region).csv"
}

# TODO(crhodes)
# Get a task that matches other examples

$taskDefinitionArn = "arn:aws:ecs:us-west-2:049751716774:task-definition/api-event:4"
get

getECSTaskDefinitionInfo $taskDefinition $region
foreach ($region in $Regions)
{
    Set-Location $outputDir
    "---------- Processing $region ----------"

    $taskDefinitions = @(getECSTaskDefinitionList $region)
    $clusters = @(getClusters $region)

    getTasksTags_FromClusters $clusters $region > "ECS_Tags_Task_$($region).csv"
}

#endregion ECS Cluster Task

#region #################### ECS Cluster Containers ####################

$cluster = $ClusterArray[0]
$region = $Regions[0]
$containerInstance = "arn:aws:ecs:us-west-2:049751716774:container-instance/noae-sbx01/84de27e814cd4ae39af06ed15965bf00"

$ci = Get-ECSContainerInstanceDetail -Region $region $cluster -ContainerInstance $containerInstance 
| Get-Member

$ciCntr = Get-ECSContainerInstanceDetail -Region $region $cluster -ContainerInstance $containerInstance | 
Select-Object -Expand ContainerInstances
$ciCntr | Get-Member

getECSContainerInstances $ClusterArray[0] $Regions[0]
getECSContainerInstances_FromClusters $ClusterArray $Regions[0]

getECSContainerInstanceInfo $ClusterArray[0] $Regions[0]
getECSContainerInstanceInfo_FromClusters $ClusterArray $Regions[0]

foreach ($region in $Regions)
{
    Set-Location $outputDir
    "---------- Processing $region ----------"

    $clusters = @(getClusters $region)

    getECSContainerInstanceInfo_FromClusters $clusters $region > "ECS_ContainerInstanceInfo_$($region).csv"
}

#endregion ECS Cluster Containers

#region #################### ECS EC2 Instance ####################

# NOTE(crhodes)
# Decide if we need this now that doing more work in PowerQuery
getEC2Instances $ClusterArray[0] $Regions[0]
getEC2Instances_FromClusters $ClusterArray $Regions[0]

foreach ($region in $Regions)
{
    Set-Location $outputDir
    "---------- Processing $region ----------"

    $clusters = @(getClusters $region)

    getEC2Instances_FromClusters $clusters $region > "ECS_EC2Instances_$($region).csv"
}

getECSContainerEC2InstanceInfo $ClusterArray[0] $Regions[0]
getECSContainerEC2InstanceInfo_FromClusters $ClusterArray $Regions[0]

foreach ($region in $Regions)
{
    Set-Location $outputDir
    "---------- Processing $region ----------"

    $clusters = @(getClusters $region)

    getECSContainerEC2InstanceInfo_FromClusters $clusters $region > "ECS_ContainerEC2InstanceInfo_$($region).csv"
}

#endregion #################### ECS EC2 ####################

#region #################### EC2 Instance ####################

$InstanceArray = @(getEC2Instances "eu-west-1")
$InstanceArray = @(getEC2Instances "eu-central-1")
$InstanceArray = @(getEC2Instances "us-east-2")
$InstanceArray = @(getEC2Instances "us-west-2")

$ec2Instance = "i-019eff05b5bc0c82a"
getEC2InstanceInfo $ec2Instance "us-east-2"

$Regions = @("us-west-2", "us-east-2", "eu-west-1", "eu-central-1")
$Regions = @("us-east-2", "eu-west-1")

foreach ($region in $Regions)
{
    Set-Location $outputDir
    "---------- Processing $region ----------"

    $instances = @(getEC2Instances $region)

    getEC2InstanceInfo_FromInstances $instances $region > "EC2_InstanceInfo_$($region).csv"
}

$region = "us-west-2"
$testInstances = @($instances[0..5])
getTags_FromEC2Instances $testInstances $region

foreach ($region in $Regions)
{
    Set-Location $outputDir
    "---------- Processing $region ----------"

    $instances = @(getEC2Instances $region)

    getTags_FromEC2Instances $instances $region > "EC2_Tags_Instance_$($region).csv"
}

# Utilization

foreach ($region in $Regions)
{
    Set-Location "$outputDir\CPU Utilization"
    "---------- Processing $region ----------"

    $instances = @(getEC2Instances $region)

    foreach($ec2InstanceId in $instances)
    {
        "Gathering CPU Utilization for $region $ec2InstanceId"

        getCWMetricsStatistics $ec2InstanceId $region | 
            ConvertTo-Csv > "CPU_Util_$($ec2InstanceId)_$($region).csv"
    }
}

# NOTE(crhodes)
# Only need to run this if InstanceTypes change

$json = Get-EC2InstanceType -Region $Regions[0] -InstanceType "m1.large" | ConvertTo-Json -Depth 10
getEC2InstanceTypes $Regions[0]

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

#endregion #################### EC2 Instance ####################

#region AS AutoScalingGroup

$region = "us-west-2"
$asGroup = "zin-prod-asg"
$asInstance = "i-04be99315aebb9dd3"

getAutoScalingGroupInfo $asGroup $region

foreach ($region in $Regions)
{
    Set-Location $outputDir
    "---------- Processing $region ----------"

    $asGroups = @(getAutoScalingGroups $region)
    
    getAutoScalingGroupInfo_FromInstances $asGroups $region  `
        > "AS_AutoScaling_Groups_$($region).csv"
}

Get-ASAutoScalingInstance -InstanceId $asGroup -Region $region
Get-ASAutoScalingInstance -InstanceId $asInstance -Region $region

$asInstances = $asInstances[0..5]
getASAutoScalingInstanceInfo_FromInstances $asInstances $region

getASAutoScalingInstanceInfo $asInstance $region

foreach ($region in $Regions)
{
    Set-Location $outputDir
    "---------- Processing $region ----------"

    $asInstances = @(getAutoScalingInstances $region)
    
    getASAutoScalingInstanceInfo_FromInstances $asInstances $region  `
        > "AS_AutoScaling_Instances_$($region).csv"
}

#endregion

################################################################################
#
# Get-EC2_ECS_Info.ps1
#
################################################################################