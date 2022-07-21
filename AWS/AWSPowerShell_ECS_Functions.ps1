################################################################################
#
# AWSPowerShell_ECS_Functions.ps1
#
################################################################################

Set-StrictMode -Version Latest

#region #################### ECS Cluster ####################

# Get-ECSClusterList
#
# SYNTAX
#   Get-ECSClusterList 
#   [-MaxResult <System.Int32>]
#   [-NextToken <System.String>]
#   [-Select <System.String>]
#   [-NoAutoIteration <System.Management.Automation.SwitchParameter>]
#   [-EndpointUrl <System.String>]
#   [-Region <System.Object>]
#   [-AccessKey <System.String>]
#   [-SecretKey <System.String>]
#   [-SessionToken <System.String>]
#   [-ProfileName <System.String>]
#   [-ProfileLocation <System.String>]
#   [-Credential <Amazon.Runtime.AWSCredentials>]
#   [-NetworkCredential <System.Management.Automation.PSCredential>]
#   [<CommonParameters>]
#

# Get-ECSClusterDetail
#
# SYNTAX
#   Get-ECSClusterDetail
#   [[-Cluster] <System.String[]>] 
#   [-Include <System.String[]>]
#   [-Select <System.String>]
#   [-PassThru <System.Management.Automation.SwitchParameter>]
#   [-EndpointUrl <System.String>]
#   [-Region <System.Object>]
#   [-AccessKey <System.String>]
#   [-SecretKey <System.String>]
#   [-SessionToken <System.String>]
#   [-ProfileName <System.String>]
#   [-ProfileLocation <System.String>]
#   [-Credential <Amazon.Runtime.AWSCredentials>]
#   [-NetworkCredential <System.Management.Automation.PSCredential>]
#   [<CommonParameters>]  
#
function getClusters([String]$region)
{
    @(Get-ECSClusterList -Region $region) | ForEach-Object {getClusterName $_}
}

function getECSClusterInfo([string]$cluster, [string]$region)
{
    # $json = Get-ECSClusterDetail -Cluster $cluster -Region $region  

    $cls = Get-ECSClusterDetail -Cluster $cluster -Region $region 
        | Select-Object -Expand Clusters

    $output = "$region,$($cls.ClusterName),$($cls.ClusterArn)"
    $output += ",$($cls.RegisteredContainerInstancesCount)"
    $output += ",$($cls.ActiveServicesCount)"
    $output += ",$($cls.PendingTasksCount)"
    $output += ",$($cls.RunningTasksCount)"
    $output += ",$($cls.Status)"

    $output
}

function getECSClusterInfo_FromClusters([string[]]$clusterArray, [string]$region)
{
    # Establish Column Headers
    # This needs to be in same order as field display in getECSClusterInfo

    $output = "Region,ClusterName,ClusterArn"
    $output += ",RegisteredContainerInstancesCount"
    $output += ",ActiveServicesCount"
    $output += ",PendingTasksCount"
    $output += ",RunningTasksCount"
    $output += ",Status"

    $output

    foreach($cluster in $clusterArray)
    {
        getECSClusterInfo $cluster $region
    }
}

function getECSClusterCapacityProviderInfo([string]$cluster, [string]$region)
{
    $cls = Get-ECSClusterDetail -Cluster $cluster -Region $region 
        | Select-Object -Expand Clusters

    $capacityProviders = $cls | Select-Object -ExpandProperty CapacityProviders

    if(0 -eq $cls.CapacityProviders.Count)
    {
        "$region,$($cls.ClusterName),"
    }
    else
    {
        foreach($cp in $capacityProviders)
        {
            $output = "$region,$($cls.ClusterName)"
            $output += ",$($cp)"
    
            $output
        }
    }
}
function getECSClusterCapacityProviderInfo_FromClusters([string[]]$clusterArray, [string]$region)
{
    # Establish Column Headers
    # This needs to be in same order as field display in getECSClusterCapacityProviderInfo

    $output = "Region,Cluster"
    $output += ",CapacityProvider"

    $output

    foreach($cluster in $clusterArray)
    {
        getECSClusterCapacityProviderInfo $cluster $region
    }
}

function getECSClusterDefaultCapacityProviderStrategyInfo([string]$cluster, [string]$region)
{
    $cls = Get-ECSClusterDetail -Cluster $cluster -Region $region 
        | Select-Object -Expand Clusters

    $defaultCapacityProviderStrategy = $cls | Select-Object -ExpandProperty DefaultCapacityProviderStrategy
    
    if(0 -eq $cls.DefaultCapacityProviderStrategy.Count)
    {
        22
    }
    else
    {    
        foreach($dcps in $defaultCapacityProviderStrategy)
        {
            $output = "$region,$($cls.ClusterName)"
            $output += ",$($dcps.Base)"
            $output += ",$($dcps.CapacityProvider)"
            $output += ",$($dcps.Weight)"                
    
            $output
        }
    }
}
function getECSClusterDefaultCapacityProviderStrategyInfo_FromClusters([string[]]$clusterArray, [string]$region)
{
    # Establish Column Headers
    # This needs to be in same order as field display in getECSClusterDefaultCapacityProviderStrategyInfo

    $output = "Region,Cluster"
    $output += ",Base"
    $output += ",CapacityProvider"
    $output += ",Weight"

    $output

    foreach($cluster in $clusterArray)
    {
        getECSClusterDefaultCapacityProviderStrategyInfo $cluster $region
    }
}
function getTags_FromClusters([string[]]$clusterArray, [string]$region)
{
    Write-Output "Region,Cluster,Key,Value"

    foreach($cluster in $clusterArray)
    {
        $json = Get-ECSClusterDetail -Cluster $cluster -Region $region -Include TAGS  

        $clusters = $json | Select-Object -Expand Clusters
        $tags = $clusters | Select-Object -Expand Tags


        if ($null -eq $tags) 
        {
            # Always output $region, $cluster even if no $tags
            "$region,$cluster,,"
        }
        else
        {
            foreach($tag in $tags)
            {
                "$region,$cluster,$($tag.Key),$($tag.Value)"
            }
        }
    }
}

#endregion ECS Cluster

#region #################### ECS Service ####################

# Get-ECSClusterService
#
# SYNTAX
#   Get-ECSClusterService
#   [[-Cluster] <System.String>]
#   [-LaunchType <Amazon.ECS.LaunchType>]
#   [-SchedulingStrategy <Amazon.ECS.SchedulingStrategy>]
#   [-MaxResult <System.Int32>]
#   [-NextToken <System.String>]
#   [-Select <System.String>]
#   [-PassThru <System.Management.Automation.SwitchParameter>]
#   [-NoAutoIteration <System.Management.Automation.SwitchParameter>]
#   [-EndpointUrl <System.String>]
#   [-Region <System.Object>]
#   [-AccessKey <System.String>]
#   [-SecretKey <System.String>]
#   [-SessionToken <System.String>]
#   [-ProfileName <System.String>]
#   [-ProfileLocation <System.String>]
#   [-Credential <Amazon.Runtime.AWSCredentials>]
#   [-NetworkCredential <System.Management.Automation.PSCredential>]
#   [<CommonParameters>]
#

# Get-ECSService
#
# SYNTAX
#   Get-ECSService
#   [[-Cluster] <System.String>]
#   [-Include <System.String[]>]
#   -Service <System.String[]>
#   [-Select <System.String>] 
#   [-PassThru <System.Management.Automation.SwitchParameter>]
#   [-EndpointUrl <System.String>]
#   [-Region <System.Object>]
#   [-AccessKey <System.String>]
#   [-SecretKey <System.String>]
#   [-SessionToken <System.String>]
#   [-ProfileName <System.String>]
#   [-ProfileLocation <System.String>] 
#   [-Credential <Amazon.Runtime.AWSCredentials>]
#   [-NetworkCredential <System.Management.Automation.PSCredential>]
#   [<CommonParameters>]
#
function getECSClusterServices([String]$cluster, [String]$region)
{
    @(Get-ECSClusterService -Cluster $cluster -Region $region)
}

function getECSClusterServices_FromClusters($clusterArray, $region)
{
    foreach($cluster in $clusterArray)
    {
        @(Get-ECSClusterService -Cluster $cluster -Region $region) | 
            ForEach-Object {getServiceName $_} | 
            ForEach-Object {"$region,$cluster,$_"}  
    }
}

function getECSClusterServicesInfo([String]$cluster, [String]$region)
{
    foreach($serviceArn in (getECSClusterServices $cluster $region))
    {
        $service = getServiceName($serviceArn)

        #  Get-ECSService -Cluster $cluster -Service $service -Region $region 
        #     | Get-Member

        # $json = Get-ECSService -Cluster $cluster -Service $service -Region $region | 
        #     ConvertTo-Json -Depth 10 | ConvertFrom-Json

        $csi = Get-ECSService -Cluster $cluster -Service $service -Region $region |
            Select-Object -Expand Services
        
        # $deployments = $csi | Select-Object -Expand Deployments

        $CreatedBy = $null -ne $csi.CreatedBy ? (getRoleName $csi.CreatedBy) : ""

        $output = "$region,$cluster"
        $output += ",$($csi.CreatedAt),$CreatedBy"
        $output += ",$($csi.DesiredCount),$($csi.Deployments.Count),$($csi.PendingCount)"
        $output += ",$(getServiceName $csi.ServiceArn),$($csi.ServiceName)"
        $output += ",$($csi.Status)"
        $output += ",$(getTaskDefinitionName $csi.TaskDefinition)"
        $output += ",$($csi.TaskDefinition)"

        $output
    }
}

function getECSClusterServicesInfo_FromClusters($clusterArray, $region)
{
    # Output Column Headers
    # This needs to be in same order as field display in getECSClusterServicesInfo

    $output = "Region,Cluster"
    $output += ",CreatedAt,CreatedBy"
    $output += ",DesiredCount,DeploymentCount,PendingCount"
    $output += ",ServiceArn,ServiceName"
    $output += ",Status"
    $output += ",TaskDefinition"
    $output += ",TaskDefinitionArn"

    $output

    foreach($cluster in $clusterArray)
    {
        getECSClusterServicesInfo $cluster $region   
    }
}

function getServicesTags_FromClusters($clusterArray, $region)
{
    Write-Output "Region,Cluster,Service,Key,Value"

    foreach($cluster in $clusterArray)
    {
        foreach($serviceArn in (getECSClusterServices $cluster $region))
        {
            $service = getServiceName($serviceArn)
    
            $csi = Get-ECSService -Cluster $cluster -Service $service -Region $region -Include TAGS | 
                Select-Object -Expand Services
    
            $tags = $csi | Select-Object -Expand Tags
        
            if ($null -eq $tags) 
            {
                # Always output $region, $cluster and $service even if no $tags
                "$region,$cluster,$service,,"
            }
            else
            {
                foreach($tag in $tags)
                {
                    "$region,$cluster,$service,$($tag.Key),$($tag.Value)"
                }
            }
        }
    }
}

#endregion ECS Cluster Sevice

#region #################### ECS Task ####################

# Get-ECSTaskList
#
# SYNTAX
#   Get-ECSTaskList
#   [[-Cluster] <System.String>]
#   [-ContainerInstance <System.String>]
#   [-DesiredStatus <Amazon.ECS.DesiredStatus>]
#   [-Family <System.String>]
#   [-LaunchType <Amazon.ECS.LaunchType>]
#   [-ServiceName <System.String>]
#   [-StartedBy <System.String>]
#   [-MaxResult <System.Int32>]
#   [-NextToken <System.String>]
#   [-Select <System.String>]
#   [-PassThru <System.Management.Automation.SwitchParameter>]
#   [-NoAutoIteration <System.Management.Automation.SwitchParameter>]
#   [-EndpointUrl <System.String>]
#   [-Region <System.Object>]
#   [-AccessKey <System.String>]
#   [-SecretKey <System.String>]
#   [-SessionToken <System.String>]
#   [-ProfileName <System.String>]
#   [-ProfileLocation <System.String>]
#   [-Credential <Amazon.Runtime.AWSCredentials>]
#   [-NetworkCredential <System.Management.Automation.PSCredential>]
#   [<CommonParameters>]

# Get-ECSTaskDetail
#
# SYNTAX
#
#   Get-ECSTaskDetail
#   [[-Cluster] <System.String>]
#   [-Include <System.String[]>]
#   -Task <System.String[]>
#   [-Select <System.String>]
#   [-PassThru <System.Management.Automation.SwitchParameter>] 
#   [-EndpointUrl <System.String>] 
#   [-Region <System.Object>]
#   [-AccessKey <System.String>]       
#   [-SecretKey <System.String>] 
#   [-SessionToken <System.String>]
#   [-ProfileName <System.String>]
#   [-ProfileLocation <System.String>]
#   [-Credential <Amazon.Runtime.AWSCredentials>]
#   [-NetworkCredential <System.Management.Automation.PSCredential>]
#   [<CommonParameters>]
#

# Get-ECSTaskDefinitionList
#
# SYNTAX
#
# Get-ECSTaskDefinitionList 
# [-FamilyPrefix <System.String>] 
# [-Sort <Amazon.ECS.SortOrder>] 
# [-Status <Amazon.ECS.TaskDefinitionStatus>]
# [-MaxResult <System.Int32>] 
# [-NextToken <System.String>] 
# [-Select <System.String>] 
# [-NoAutoIteration <System.Management.Automation.SwitchParameter>] 
# [-EndpointUrl <System.String>] 
# [-Region <System.Object>] 
# [-AccessKey <System.String>]      
# [-SecretKey <System.String>] 
# [-SessionToken <System.String>] 
# [-ProfileName <System.String>] 
# [-ProfileLocation <System.String>] 
# [-Credential <Amazon.Runtime.AWSCredentials>] 
# [-NetworkCredential <System.Management.Automation.PSCredential>]
# [<CommonParameters>]
#

function getECSTasks($cluster, $region)
{
    @(Get-ECSTaskList -Cluster $cluster -Region $region)

    # TODO(crhodes)
    # Throws error for some $cluster ??

    # Line |
    # 321 |      @(Get-ECSTaskList -Cluster $cluster -Region $region)
    #     |        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    #     | No region specified or obtained from persisted/shell defaults.    

}

function getECSTasks_FromClusters($clusterArray, $region)
{
    foreach($cluster in $clusterArray)
    {
        @(Get-ECSTaskList -Cluster $cluster -Region $region) | 
            ForEach-Object {getTaskName $_} | 
            ForEach-Object {"$region,$cluster,$_"}  
    }
}

function getECSTaskInfo([String]$cluster, $region)
{
    foreach($taskArn in (getECSTasks $cluster $region))
    {
        $task = getTaskName($taskArn)

        $containerCPU = 0
        $containerMemory = 0

        # Get-ECSTaskDetail -Cluster $cluster -Task $task -Region $region 
        #     | Get-Member

        # $json = Get-ECSTaskDetail -Cluster $cluster -Task $task -Region $region |
        #     ConvertTo-Json -Depth 10

        $tsk = Get-ECSTaskDetail -Cluster $cluster -Task $task -Region $region | 
            Select-Object -Expand Tasks     

        $output = "$region," + (getClusterName $($tsk.ClusterArn))

        $output += ",$($tsk.ContainerInstanceArn)"
        $output += ",$($tsk.LaunchType.Value)"
        $output += ",$($tsk.AvailabilityZone)"
        $output += ",$($tsk.Cpu),$($tsk.Memory)"
        $output += ",$($tsk.DesiredStatus),$($tsk.LastStatus)"
        $output += "," + (getTaskName($($tsk.TaskArn)))
        $output += "," + (getTaskDefinitionName($($tsk.TaskDefinitionArn)))
        $output += ",$($tsk.TaskDefinitionArn)"
        $output += ",$($tsk.Version)"
        $output += ",$($tsk.StartedAt),$($tsk.StoppedAt)"
        $output += ",$($tsk.Group)"
        $output += ",$($tsk.CapacityProviderName)"
        $output += ",$($tsk.Containers.Count)"

        $taskContainers = $tsk | Select-Object -Expand Containers

        foreach($container in $taskContainers)
        {
            $containerCPU += $container.CPU
            $containerMemory += $container.Memory
        }

        $output += ",$($containerCPU),$($containerMemory)"

        $output
    }
}

function getECSTaskInfo_FromClusters($clusterArray, $region)
{
    # Establish Column Headers
    # This needs to be in same order as field display in getECSTaskInfo

    $output = "Region,Cluster"
    $output += ",ContanerInstanceArn"
    $output += ",LaunchType"
    $output += ",AvailabilityZone"
    $output += ",Cpu,Memory"
    $output += ",DesiredStatus,LastStatus"
    $output += ",Task"
    $output += ",TaskDefinition"
    $output += ",TaskDefinitionArn"
    $output += ",Version"
    $output += ",StartedAt,StoppedAt"
    $output += ",Group"
    $output += ",CapacityProvider"
    $output += ",ContainerCount"
    $output += ",ContainerCPU,ContainerMemory"

    $output

    foreach($cluster in $clusterArray)
    {
        getECSTaskInfo $cluster $region
    }
}

function getECSTaskContainerInfo([String]$cluster, $region)
{
    foreach($taskArn in (getECSTasks $cluster))
    {
        $task = getTaskName $taskArn

        $json = Get-ECSTaskDetail -Cluster $cluster -Task $task -Region $region 

        $tsk = $json | Select-Object -Expand Tasks
        $cntr = $tsk | Select-Object -Expand Containers

        $output = "$region," + (getClusterName $($tsk.ClusterArn))
        $output += "," + (getContainerInstancename($($tsk.ContainerInstanceArn)))
        $output += ",$($cntr.ContainerArn)"
        $output += ",$($cntr.Cpu),$($cntr.Memory)"        
        $output += ",$($cntr.ExitCode),$($cntr.LastStatus)"
        $output += ",$($cntr.Name),$($cntr.Image)"

        $output
    }
}
function getECSTaskContainerInfo_FromClusters($clusterArray, $region)
{
    # Establish Column Headers
    # This needs to be in same order as field display in getECSTaskContainerInfo

    $output = "Region,Cluster"
    $output += ",ContanerInstance"
    $output += ",Conainer"
    $output += ",Cpu,Memory"
    $output += ",ExitCode,LastStatus"
    $output += ",Name,Image"

    $output

    foreach($cluster in $clusterArray)
    {
        getECSTaskContainerInfo $cluster $region
    }
}

function getTasksTags_FromClusters($clusterArray, $region)
{
    Write-Output "Region,Cluster,Task,Key,Value"

    foreach($cluster in $clusterArray)
    {
        foreach($taskArn in (getECSTasks $cluster $region))
        {
            $task = getTaskName($taskArn)

            $json = Get-ECSTaskDetail -Cluster $cluster -Task $task -Region $region -Include TAGS
    
            $tsk = $json | Select-Object -Expand Tasks

            $tags = $tsk | Select-Object -Expand Tags
    
            if ($null -eq $tags) 
            {
                # Always output $region, $cluster, and $service even if no $tags
                "$region,$cluster,$task,,"
            }
            else
            {
                foreach($tag in $tags)
                {
                    "$region,$cluster,$task,$($tag.Key),$($tag.Value)"
                }
            }
        }
    }
}

#endregion ECS Cluster Task

#region #################### ECS Task Definition ####################

# Get-ECSTaskDefinitionDetail
#
# SYNTAX
#
# Get-ECSTaskDefinitionDetail 
# [-TaskDefinition] <System.String> 
# [-Include <System.String[]>] 
# [-Select <System.String>] 
# [-PassThru <System.Management.Automation.SwitchParameter>] 
# [-EndpointUrl <System.String>] 
# [-Region <System.Object>] 
# [-AccessKey <System.String>]      
# [-SecretKey <System.String>] 
# [-SessionToken <System.String>] 
# [-ProfileName <System.String>]
# [-ProfileLocation <System.String>] 
# [-Credential <Amazon.Runtime.AWSCredentials>] 
# [-NetworkCredential <System.Management.Automation.PSCredential>] 
# [<CommonParameters>]
#

# Get-ECSTaskDefinitionFamilyList
#
# SYNTAX
#
# Get-ECSTaskDefinitionFamilyList 
# [-FamilyPrefix <System.String>] 
# [-Status <Amazon.ECS.TaskDefinitionFamilyStatus>] 
# [-MaxResult <System.Int32>]
# [-NextToken <System.String>] 
# [-Select <System.String>]
# [-NoAutoIteration <System.Management.Automation.SwitchParameter>] 
# [-EndpointUrl <System.String>] 
# [-Region <System.Object>] 
# [-AccessKey <System.String>]      
# [-SecretKey <System.String>] 
# [-SessionToken <System.String>] 
# [-ProfileName <System.String>] 
# [-ProfileLocation <System.String>] 
# [-Credential <Amazon.Runtime.AWSCredentials>] 
# [-NetworkCredential <System.Management.Automation.PSCredential>] 
# [<CommonParameters>]
#

function getECSTaskDefinitionFamilyList([string]$region)
{
    $families = Get-ECSTaskDefinitionFamilyList -Region $region

    foreach($family in $families)
    {
        $output = "$region,$family"

        $output
    }
}

function getECSTaskDefinitionList([string]$region)
{
    $taskDefinitions = Get-ECSTaskDefinitionList -Region $region

    foreach($taskDef in $taskDefinitions)
    {
        $output = "$region"
        $output += "," + (getTaskDefinitionFullName $taskDef)

        $output
    }
}

function getECSTaskDefinitionInfo([String]$taskDefinitionArn, $region)
{
    $taskDefinition = getTaskDefinitionName($taskDefinitionArn)

    $containerCPU = 0
    $containerMemory = 0

    # Get-ECSTaskDefinitionDetail -TaskDefinition $taskDefinition -Region $region 
    #     | Get-Member

    # $json = Get-ECSTaskDefinitionDetail -TaskDefinition $taskDefinition -Region $region 
    #     | ConvertTo-Json -Depth 10

    $taskDef = Get-ECSTaskDefinitionDetail -TaskDefinition $taskDefinitionArn -Region $region | 
        Select-Object -Expand TaskDefinition
        
    $output = "$region"
    $output += ",$($taskDef.Cpu),$($taskDef.Memory)"
    $output += ",$($taskDef.Revision)"
    $output += ",$($taskDef.Status)"
    $output += ",$($taskDef.TaskDefinitionArn)"
    $output += ",$($taskDef.TaskRoleArn)"
    $output += ",$($taskDef.ContainerDefinitions.Count)"

    $taskContainerDefinitions = $taskDef | Select-Object -Expand ContainerDefinitions

    foreach($containerDef in $taskContainerDefinitions)
    {
        $containerCPU += $containerDef.CPU
        $containerMemory += $containerDef.Memory
    }

    $output += ",$($containerCPU),$($containerMemory)"    

    $output
}

function getECSTaskDefinitionInfo_FromRegion([String]$region)
{
    $header = "Region"
    $header += ",CPU,Memory"
    $header += ",Revision"
    $header += ",Status"
    $header += ",TaskDefinitionArn"
    $header += ",TaskRoleArn"
    $header += ",ContainerDefinitionCount"
    $header += ",ContainerCPU,ContainerMemory"

    $header

    foreach($taskDef in (Get-ECSTaskDefinitionList -Region $region))
    {
        getECSTaskDefinitionInfo $taskDef $region
    }
}

#endregion ECS Task Definition

#region #################### ECS Cluster Containers ####################

# Get-ECSContainerInstanceList
#
# SYNTAX
#   Get-ECSContainerInstanceList
#   [[-Cluster] <System.String>]
#   [-Filter <System.String>]
#   [-Status <Amazon.ECS.ContainerInstanceStatus>]
#   [-MaxResult <System.Int32>]
#   [-NextToken <System.String>]
#   [-Select <System.String>]
#   [-PassThru <System.Management.Automation.SwitchParameter>]
#   [-NoAutoIteration <System.Management.Automation.SwitchParameter>]
#   [-EndpointUrl <System.String>]
#   [-Region <System.Object>]
#   [-AccessKey <System.String>]
#   [-SecretKey <System.String>]
#   [-SessionToken <System.String>]
#   [-ProfileName <System.String>]
#   [-ProfileLocation <System.String>]
#   [-Credential <Amazon.Runtime.AWSCredentials>]
#   [-NetworkCredential <System.Management.Automation.PSCredential>]
#   [<CommonParameters>]
#

# Get-ECSContainerInstanceDetail
# #
# SYNTAX
#   Get-ECSContainerInstanceDetail
#   [[-Cluster] <System.String>]
#   -ContainerInstance <System.String[]>
#   [-Include <System.String[]>]
#   [-Select <System.String>] 
#   [-PassThru <System.Management.Automation.SwitchParameter>]        
#   [-EndpointUrl <System.String>]
#   [-Region <System.Object>]
#   [-AccessKey <System.String>]
#   [-SecretKey <System.String>]
#   [-SessionToken <System.String>]
#   [-ProfileName <System.String>]
#   [-ProfileLocation <System.String>]
#   [-Credential <Amazon.Runtime.AWSCredentials>]
#   [-NetworkCredential <System.Management.Automation.PSCredential>]
#   [<CommonParameters>]
#
function getECSContainerInstances($cluster, $region)
{
    @(Get-ECSContainerInstanceList -Cluster $cluster -Region $region)
}

function getECSContainerInstances_FromClusters($clusterArray, $region)
{
    foreach($cluster in $clusterArray)
    {
        @(Get-ECSContainerInstanceList -Cluster $cluster -Region $region) | 
            ForEach-Object {getContainerInstanceName $_} | 
            ForEach-Object {"$region,$cluster,$_"}  
    }
}

function getECSContainerInstanceInfo([String]$cluster, $region)
{
    foreach($container in (getECSContainerInstances $cluster $region))
    {
        $clsn = getContainerInstanceName $container

        # Get-ECSContainerInstanceDetail -Cluster $cluster -ContainerInstance $clsn -Region $region | Get-Member

        # $json = Get-ECSContainerInstanceDetail -Cluster $cluster -ContainerInstance $clsn -Region $region | 
        #     ConvertTo-Json -Depth 10 | ConvertFrom-Json

        $cntr = Get-ECSContainerInstanceDetail -Cluster $cluster -ContainerInstance $clsn -Region $region | 
            Select-Object -ExpandProperty ContainerInstances

        # $cntr | Get-Member

        $Registered = $cntr | Select-Object -ExpandProperty RegisteredResources
        $Remaining = $cntr | Select-Object -ExpandProperty RemainingResources

        $regCpu = $Registered | Where-Object -Property Name -eq "CPU"
        $regMem = $Registered | Where-Object -Property Name -eq "MEMORY"

        $remCpu = $Remaining | Where-Object -Property Name -eq "CPU"
        $remMem = $Remaining | Where-Object -Property Name -eq "MEMORY"

        $output = "$region,$cluster"
        $output += ",$($cntr.CapacityProviderName)"
        # $output += "," + (getContainerInstancename($($cntr.ContainerInstanceArn)))        
        $output += ",$($cntr.ContainerInstanceArn)"
        $output += ",$($cntr.Ec2InstanceId)"
        $output += ",$($cntr.PendingTasksCount),$($cntr.RunningTasksCount)"
        $output += ",$($cntr.Status),$($cntr.Version)"

        $output += ",$($regCpu.IntegerValue),$($remCpu.IntegerValue),$($regMem.IntegerValue),$($remMem.IntegerValue)"

        $output
    }
}

function getECSContainerInstanceInfo_FromClusters($clusterArray, $region)
{
    # Establish Column Headers
    # This needs to be in same order as field display in getECSContainerInstanceInfo

    $output = "Region,Cluster"
    $output += ",CapacityProvider"
    $output += ",ContainerInstanceArn"
    $output += ",Ec2InstanceId"
    $output += ",PendingTasksCount,RunningTasksCount"
    $output += ",Status,Version"
    $output += ",Registered CPU,Remaining CPU,Registered Memory,Remaining Memory"

    $output

    foreach($cluster in $clusterArray)
    {
        getECSContainerInstanceInfo $cluster $region
    }
}

#endregion ECS Cluster Containers

#region #################### ECS Cluster <-> EC2 Instance ####################

function getECSContainerEC2InstanceInfo([String]$cluster, $region)
{
    foreach($containerArn in (getECSContainerInstances $cluster $region))
    {
        $containerInstance = getContainerInstanceName($containerArn)
        $json = Get-ECSContainerInstanceDetail -Cluster $cluster -ContainerInstance $containerInstance -Region $region

        $cntr = $json | Select-Object -ExpandProperty ContainerInstances

        $ec2i = Get-EC2Instance -InstanceID $cntr.Ec2InstanceId -Region $region
        $ec2ie = $ec2i | Select-Object -Expand Instances
        $ec2rie = $ec2i | Select-Object -Expand RunningInstance

        # $ec2ie.Architecture
        # $ec2ie.CpuOptions.CoreCount
        # $ec2ie.CpuOptions.ThreadsPerCore
        $hypervisor = $ec2ie.Hypervisor.Value
        # $ec2ie.InstanceType.Value
        # $ec2ie.Placement.AvailabilityZone
        $rootDeviceType = $ec2ie.RootDeviceType.Value
        $state = $ec2ie.State.Name.Value
        $virtualizationType = $ec2ie.VirtualizationType.Value

        $output = "$region,$cluster,$containerInstance,$($cntr.Ec2InstanceId)"

        $output += ",$($ec2i.OwnerId),$($ec2i.RequesterId),$($ec2i.ReservationId)"

        $output += ",$($ec2ie.InstanceType.Value),$($ec2ie.CpuOptions.CoreCount),$($ec2ie.CpuOptions.ThreadsPerCore)"
        $output += ",$($ec2ie.Placement.AvailabilityZone)"
        #$output += ",$($ec2ei.RootDeviceType.Value)"
        $output += ",$rootDeviceType"
        # $output += ",$($ec2ei.Hypervisor.Value),$($ec2ei.VirtualizationType.Value)"
        $output += ",$hypervisor,$virtualizationType"
        # $output += ",$($ec2ei.State.Name.Value)"
        $output += ",$state"
    
        $output
    }
}
function getECSContainerEC2InstanceInfo_FromClusters($clusterArray, $region)
{
    # Establish Column Headers
    # This needs to be in same order as field display in getEC2InstanceInfo

    $output = "Region,Cluster,Container,Ec2InstanceID"
    $output = ",OwnerId,RequesterId,ReservationId"
    $output += ",InstanceType,CoreCount,ThreadsPerCore"
    $output += ",AvailabilityZone"
    $output += ",RootDeviceType"
    $output += ",Hypervisor,VirualizationType"
    $output += ",State"

    $output

    foreach($cluster in $clusterArray)
    {
        getECSContainerEC2InstanceInfo $cluster $region
    }
}

#endregion

################################################################################
#
# End AWSPowerShell_ECS_Functions.ps1
#
################################################################################