################################################################################
#
# RefreshDataFunctions.ps1
#
################################################################################

Set-StrictMode -Version Latest

#region #################### EC2 Utilization ####################

$region = "us-west-2"

$ec2InstanceId = "i-57542c92"
getEC2InstanceInfo $ec2InstanceId $region

$startTime.ToUniversalTime()
$endTime.ToUniversalTime()

getCW_EC2_CPUUtilization $ec2InstanceId $region $startTime $endTime

$Regions = @("us-west-2", "us-east-2", "eu-west-1", "eu-central-1")
$Regions = @("us-east-2", "eu-west-1")

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

        $header = "Region,EC2InstanceId,TimeStamp,Minimum,Average,Maximum"
        $header > $outputFile

        "Gathering CPU Utilization for $region $ec2InstanceId"

        getCW_EC2_CPUUtilization $ec2InstanceId $region $startTime $endTime `
            >> $outputFile
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
$Regions = @("us-east-2", "eu-west-1")

foreach ($region in $Regions)
{
    $startTime = Get-Date -Date "2022-06-01 00:00:00Z"
    $endTime = Get-Date -Date "2022-06-30 23:59:59Z"

    # $startTime = Get-Date -Date "2022-07-01 00:00:00Z"
    # $endTime = Get-Date -Date "2022-07-12 23:59:59Z"

    $regionOutputDirectory = "$outputDir\Cluster_Service_Utilization\2022-06\$region"
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

# $region, [String]$cluster, $startTime, $endTime, $outputDir, [switch]$noData
function GetClusterUtilizationDataFiles()
{
    [CmdletBinding()]
    param (
        [Parameter()]
        [string] $region
        , [String]$cluster
        , $startTime
        , $endTime
        , $outputDir
        , [switch]$IncludeCluster
        , [switch]$IncludeService
        , [switch]$IncludeTask
        , [switch]$GatherData
    )

    Set-Location $outputDir

    if ($IncludeCluster)
    {
        if ($GatherData)
        {
            getClusterUtilizationData $region $cluster $startTime $endTime $outputDir -GatherData
        }
        else
        {
            getClusterUtilizationData $region $cluster $startTime $endTime $outputDir
        }        
    }

    if ($IncludeService)
    {
        if ($GatherData)
        {
            getServiceUtilizationData $region $cluster $startTime $endTime $outputDir -GatherData
        }
        else
        {
            getServiceUtilizationData $region $cluster $startTime $endTime $outputDir
        }  
    }    

    if ($includeTask)
    {
        # "---------- Processing ContainerInstances for $cluster $region ---------- "

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
    
        # }
    }
}

function getClusterUtilizationData()
{
    [CmdletBinding()]
    param (
        [Parameter()]
        [string] $region
        , [String]$cluster
        , $startTime
        , $endTime
        , $outputDir
        # , [switch]$IncludeCluster
        # , [switch]$IncludeService
        # , [switch]$IncludeTask
        , [switch]$GatherData
    )

    ">>>> Processing Cluster $cluster in $region"

    # $outputFile = "C-$($cluster)_$(getRegionAbbreviation $region).csv" 
    $outputFile = "C-$($cluster).csv" 

    if($GatherData)
    {
        "Region,$($region)" > $outputFile
        "Cluster,$($cluster)" >> $outputFile
        "" >> $outputFile
        "StartTime,,$($startTime)" >> $outputFile
        "EndTime,,$($endTime)" >> $outputFile        
        "Region,Cluster,TimeStamp,Minimum,Average,Maximum" >> $outputFile

        getCW_ECS_Cluster_CPUUtilization $cluster $region $startTime $endTime >> $outputFile
    }
}

function getServiceUtilizationData()
{
    [CmdletBinding()]
    param (
        [Parameter()]
        [string] $region
        , [String]$cluster
        , $startTime
        , $endTime
        , $outputDir
        # , [switch]$IncludeCluster
        # , [switch]$IncludeService
        # , [switch]$IncludeTask
        , [switch]$GatherData
    )

    ">>>>>> Processing Services for Cluster $cluster in $region "

    foreach($serviceArn in (getECSClusterServices $cluster $region))
    {
        $service = getServiceName($serviceArn)

        "        Adding $region $cluster $service"
        
        $csi = Get-ECSService -Cluster $cluster -Service $service -Region $region |
            Select-Object -Expand Services

        $serviceName = $csi.ServiceName

        # $outputFile = "S-$($serviceName)_$(getRegionAbbreviation $region).csv"
        $outputFile = "S-$($serviceName).csv"
            
        if ($GatherData)
        {
            "Region,$($region)" > $outputFile
            "Cluster,$($cluster)" >> $outputFile
            "Service,$($service)" >> $outputFile
            "StartTime,,$($startTime)" >> $outputFile
            "EndTime,,$($endTime)" >> $outputFile  
            "Region,Service,TimeStamp,Minimum,Average,Maximum" >> $outputFile            

            getCW_ECS_Service_CPUUtilization $cluster $serviceName $region $startTime $endTime >> $outputFile
        }
    }
}

# $cluster = "zsystemcm-cnc00"
# $region = "us-east-2"
# $startTime
# $endTime
# $serviceName = "filebeat"

# $cluster
# $region
# $startTime
# $endTime
# $serviceName


# $outputFile = "$($cluster)_$($region).csv"

# $header = "Region,Cluster,TimeStamp,Minimum,Average,Maximum"
# $header > $outputFile

# getCW_ECS_Cluster_CPUUtilization $cluster $region $startTime $endTime >> $outputFile


# $cluster = "noae-sbx01"



# $service = "notification"

# $cluster
# $service
# $region
# $startTime
# $endTime

# $outputFile = "$($cluster)_$($service)_$(getRegionAbbreviation $region).csv"

# $header = "Region,Service,TimeStamp,Minimum,Average,Maximum"
# $header > $outputFile

# getCW_ECS_Service_CPUUtilization $cluster $service $region $startTime $endTime >> $outputFile


#endregion #################### EC2 Utilization ####################

################################################################################
#
# Refresh_Utilization_Functions.ps1
#
################################################################################