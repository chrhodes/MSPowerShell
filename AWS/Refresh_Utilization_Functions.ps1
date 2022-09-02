################################################################################
#
# RefreshDataFunctions.ps1
#
################################################################################

Set-StrictMode -Version Latest

#region #################### EC2 Utilization ####################

function gatherEC2UtilizationMetricsForRegion(
    [string]$outputDir,
    [string]$yearMonth,    
    [string]$region,
    [System.DateTime]$startTime, [System.DateTime]$endTime
)
{
    Set-Location "$($outputDir)\EC2_Utilization"
    $outputDirYearMonth = "$($outputDir)\EC2_Utilization\$($yearMonth)"

    if (!(Test-Path -Path $yearMonth)) { New-Item -Name $yearMonth -ItemType Directory } 

    Set-Location $outputDirYearMonth

    if (!(Test-Path -Path $region)) { New-Item -Name $region -ItemType Directory }    

    $regionOutputDirectory = "$($outputDirYearMonth)\$($region)"

    ">> Processing $region"

    $instances = @(getEC2Instances $region)

    Set-Location $regionOutputDirectory

    foreach($ec2InstanceId in $instances)
    {
        if (!(Test-Path -Path $ec2InstanceId)) { New-Item -Name $ec2InstanceId -ItemType Directory } 

        Set-Location $ec2InstanceId
        
        gatherEC2Metric "CPUUtilization" $ec2InstanceId $region $startTime $endTime -GatherData
        
        gatherEC2Metric "NetworkIn" $ec2InstanceId $region $startTime $endTime -GatherData
        gatherEC2Metric "NetworkOut" $ec2InstanceId $region $startTime $endTime -GatherData

        gatherEC2Metric "DiskReadOps" $ec2InstanceId $region $startTime $endTime -GatherData
        gatherEC2Metric "DiskWriteOps" $ec2InstanceId $region $startTime $endTime -GatherData

        gatherEC2Metric "EBSReadOps" $ec2InstanceId $region $startTime $endTime -GatherData                  
        gatherEC2Metric "EBSWriteOps" $ec2InstanceId $region $startTime $endTime -GatherData

        Set-Location $regionOutputDirectory
    } 
}

function gatherEC2Metric(
    [string]$metricName, 
    [string]$ec2InstanceId, [string]$region, 
    [System.DateTime]$startTime, [System.DateTime]$endTime,
    [switch]$GatherData)
{
        $outputFile = "$($ec2InstanceId)_$($metricName)_$($region).csv"

        "Gathering $metricName Utilization for $region $ec2InstanceId"

        if ($GatherData)
        {
            "Region,$($region)" > $outputFile
            "ec2Instance,$($ec2InstanceId)" >> $outputFile
            "Metric,$($metricName)" >> $outputFile
            "StartTime,,$($startTime)" >> $outputFile
            "EndTime,,$($endTime)" >> $outputFile              

            "Region,EC2InstanceId,TimeStamp,Minimum,Average,Maximum" >> $outputFile        

            getCW_EC2_MetricUtilization $metricName $ec2InstanceId $region $startTime $endTime `
                >> $outputFile
        }
}

#endregion #################### EC2 Utilization ####################

#region #################### ECS Utilization ####################

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

    $arn = Get-ECSClusterDetail -Cluster $cluster -Region $region | 
        Select-Object -Expand Clusters | 
        Select-Object -Property ClusterArn

    $outputFile = "CC-$($cluster).csv"         

    "  >> Gathering CPU Utilization Data"

    if($GatherData)
    {
        "Region,$($region),CPU" > $outputFile
        "ClusterArn,$($arn.ClusterArn)" >> $outputFile
        "" >> $outputFile
        "StartTime,,$($startTime)" >> $outputFile
        "EndTime,,$($endTime)" >> $outputFile        
        "Region,Cluster,TimeStamp,Minimum,Average,Maximum" >> $outputFile

        getCW_ECS_Cluster_CPUUtilization $cluster $region $startTime $endTime >> $outputFile
    }

    $outputFile = "CM-$($cluster).csv"         

    "  >> Gathering Memory Utilization Data"

    if($GatherData)
    {
        "Region,$($region),Memory" > $outputFile
        "ClusterArn,$($arn.ClusterArn)" >> $outputFile
        "" >> $outputFile
        "StartTime,,$($startTime)" >> $outputFile
        "EndTime,,$($endTime)" >> $outputFile        
        "Region,Cluster,TimeStamp,Minimum,Average,Maximum" >> $outputFile

        getCW_ECS_Cluster_MemoryUtilization $cluster $region $startTime $endTime >> $outputFile
    }    
}

# Get-ECSClusterDetail -Cluster $cluster -Region $region | Select-Object -Expand Clusters | Select-Object -Property ClusterArn

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

    $arn = Get-ECSClusterDetail -Cluster $cluster -Region $region | 
        Select-Object -Expand Clusters | 
        Select-Object -Property ClusterArn

    $clusterArn = $arn.ClusterArn

    "    >>>> Processing Services for Cluster $cluster in $region "

    foreach($serviceArn in (getECSClusterServices $cluster $region))
    {
        $service = getServiceName($serviceArn)

        "           Adding $region $cluster $service"
        
        $csi = Get-ECSService -Cluster $cluster -Service $service -Region $region |
            Select-Object -Expand Services

        $serviceName = $csi.ServiceName

        # $outputFile = "S-$($serviceName)_$(getRegionAbbreviation $region).csv"
        $outputFile = "SC-$($serviceName).csv"

        "               >> Gathering CPU Utilization Data"
            
        if ($GatherData)
        {
            "Region,$($region),CPU" > $outputFile
            "ClusterArn,$($clusterArn)" >> $outputFile
            "ServiceArn,$($serviceArn)" >> $outputFile
            "StartTime,,$($startTime)" >> $outputFile
            "EndTime,,$($endTime)" >> $outputFile  
            "Region,Service,TimeStamp,Minimum,Average,Maximum" >> $outputFile            

            getCW_ECS_Service_CPUUtilization $cluster $serviceName $region $startTime $endTime >> $outputFile
        }

        $outputFile = "SM-$($serviceName).csv"

        "               >> Gathering Memory Utilization Data"
            
        if ($GatherData)
        {
            "Region,$($region),Memory" > $outputFile
            "ClusterArn,$($clusterArn)" >> $outputFile
            "ServiceArn,$($serviceArn)" >> $outputFile
            "StartTime,,$($startTime)" >> $outputFile
            "EndTime,,$($endTime)" >> $outputFile  
            "Region,Service,TimeStamp,Minimum,Average,Maximum" >> $outputFile            

            getCW_ECS_Service_MemoryUtilization $cluster $serviceName $region $startTime $endTime >> $outputFile
        }        
    }
}

#endregion #################### ECS Utilization ####################

################################################################################
#
# Refresh_Utilization_Functions.ps1
#
################################################################################