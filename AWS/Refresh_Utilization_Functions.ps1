################################################################################
#
# RefreshDataFunctions.ps1
#
################################################################################

Set-StrictMode -Version Latest

#region #################### EC2 Utilization ####################

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


#endregion#################### ECS Utilization ####################

################################################################################
#
# Refresh_Utilization_Functions.ps1
#
################################################################################