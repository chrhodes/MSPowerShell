################################################################################
#
# AWSPowerShell_ECSFunctions.ps1
#
################################################################################

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
    $json = Get-ECSClusterDetail -Cluster $cluster -Region $region | 
        ConvertTo-Json -Depth 5 | ConvertFrom-Json

    $cls = $json | Select-Object -Expand Clusters

    $output = "$region,$($cls.ClusterName)"
    $output += ",$($cls.RegisteredContainerInstancesCount),$($cls.ActiveServicesCount)"
    $output += ",$($cls.PendingTasksCount),$($cls.RunningTasksCount),$($cls.Status)"

    $output
}

function getECSClusterInfo_FromClusters([string[]]$clusterArray, [string]$region)
{
    # Establish Column Headers
    # This needs to be in same order as field display in getECSClusterInfo

    $output = "Region,Cluster"
    $output += ",RegisteredContainerInstancesCount,ActiveServicesCount"
    $output += ",PendingTasksCount,RunningTasksCount,Status"

    $output

    foreach($cluster in $clusterArray)
    {
        getECSClusterInfo $cluster $region
    }
}

function getTags_FromClusters([string[]]$clusterArray, [string]$region)
{
    Write-Output "Region,Cluster,Key,Value"

    foreach($cluster in $clusterArray)
    {
        $json = Get-ECSClusterDetail -Cluster $cluster -Region $region -Include TAGS | 
            ConvertTo-Json -Depth 5 | ConvertFrom-Json

        $clusters = $json | Select-Object -Expand Clusters
        $tags = $clusters | Select-Object -Expand Tags

        foreach($tag in $tags)
        {
            "$region,$cluster,$($tag.Key),$($tag.Value)"
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

function getECSClusterServices([String]$cluster, $region)
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

function getECSClusterServicesInfo([String]$cluster, [string]$region)
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

        $CreatedBy = $null -ne $csi.CreatedBy ? (getRoleName $csi.CreatedBy) : ""

        $output = "$region,$cluster"
        $output += ",$($csi.CreatedAt),$CreatedBy"
        $output += ",$($csi.DesiredCount),$($csi.PendingCount)"
        $output += ",$($csi.ServiceName),$($csi.Status)"

        $output
    }
}

function getECSClusterServicesInfo_FromClusters($clusterArray, $region)
{
    # Output Column Headers
    # This needs to be in same order as field display in getECSClusterServicesInfo

    $output = "Region,Cluster"
    $output += ",CreatedAt,CreatedBy"
    $output += ",DesiredCount,PendingCount"
    $output += ",ServiceName,Status"

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
    
            $csi = $json | Select-Object -Expand Services

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

        # Get-ECSTaskDetail -Cluster $cluster -Task $task -Region $region 
        #     | Get-Member

        # $json = Get-ECSTaskDetail -Cluster $cluster -Task $task -Region $region |
        #     ConvertTo-Json -Depth 10

        $tsk = Get-ECSTaskDetail -Cluster $cluster -Task $task -Region $region | 
            Select-Object -Expand Tasks     

        $output = "$region," + (getClusterName $($tsk.ClusterArn))

        $output += "," + (getContainerInstancename($($tsk.ContainerInstanceArn)))
        $output += ",$($tsk.LaunchType.Value)"
        $output += ",$($tsk.AvailabilityZone),$($tsk.Cpu),$($tsk.Memory)"
        $output += ",$($tsk.DesiredStatus),$($tsk.LastStatus)"
        $output += "," + (getTaskName($($tsk.TaskArn)))
        $output += "," + (getTaskDefinitionName($($tsk.TaskDefinitionArn)))
        $output += ",$($tsk.Version)"
        $output += ",$($tsk.StartedAt)"

        $output
    }
}

function getECSTaskInfo_FromClusters($clusterArray, $region)
{
    # Establish Column Headers
    # This needs to be in same order as field display in getECSTaskInfo

    $output = "Region,Cluster"
    $output += ",ContanerInstance"
    $output += ",LaunchType"
    $output += ",AvailabilityZone,Cpu,Memory"
    $output += ",DesiredStatus,LastStatus"
    $output += ",Task"
    $output += ",TaskDefinition"
    $output += ",Version"
    $output += ",StartedAt"

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

        $json = Get-ECSTaskDetail -Cluster $cluster -Task $task -Region $region | 
            ConvertTo-Json -Depth 10 | ConvertFrom-Json

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

            $json = Get-ECSTaskDetail -Cluster $cluster -Task $task -Region $region -Include TAGS | 
                ConvertTo-Json -Depth 10 | ConvertFrom-Json
    
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

    # Get-ECSTaskDefinitionDetail -TaskDefinition $taskDefinition -Region $region 
    #     | Get-Member

    # $json = Get-ECSTaskDefinitionDetail -TaskDefinition $taskDefinition -Region $region 
    #     | ConvertTo-Json -Depth 10

    # $json = Get-ECSTaskDetail -Cluster $cluster -Task $task -Region $region |
    #     ConvertTo-Json -Depth 10

    $taskDef = Get-ECSTaskDefinitionDetail -TaskDefinition $taskDefinition -Region $region | 
        Select-Object -Expand TaskDefinition
        
    $taskDef | Get-Member

    $containerDef = $taskDef | Select-Object -Expand ContainerDefinitions

    $containerDef | Get-Member

    $output = "$region," + (getClusterName $($tsk.ClusterArn))

    $output += "," + (getContainerInstancename($($tsk.ContainerInstanceArn)))
    $output += ",$($tsk.LaunchType.Value)"
    $output += ",$($tsk.AvailabilityZone),$($tsk.Cpu),$($tsk.Memory)"
    $output += ",$($tsk.DesiredStatus),$($tsk.LastStatus)"
    $output += "," + (getTaskName($($tsk.TaskArn)))
    $output += ",$($tsk.TaskDefinitionArn)"
    $output += ",$($tsk.Version)"
    $output += ",$($tsk.StartedAt)"

    $output
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
        $output += "," + (getContainerInstancename($($cntr.ContainerInstanceArn)))
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
    $output += ",ContainerInstance"
    $output += ",Ec2InstanceId"
    $output += ",PendingTasksCount,RunningTasksCount"
    $output += ",Status,Version"
    $output += ",Registered CPU,Rememaining CPU,Registered Memory,Remaining Memory"

    $output

    foreach($cluster in $clusterArray)
    {
        getECSContainerInstanceInfo $cluster $region
    }
}

#endregion ECS Cluster Containers

#region #################### ECS Cluster <-> EC2 Instance ####################

function getEC2Instances([String]$cluster, $region)
{
    foreach($containerArn in (getECSContainerInstances $cluster $region))
    {
        $container = getContainerInstanceName($containerArn)

        $json = Get-ECSContainerInstanceDetail -Cluster $cluster -ContainerInstance $container -Region $region |
            ConvertTo-Json -Depth 10 | ConvertFrom-Json

        $cni = $json | Select-Object -ExpandProperty ContainerInstances

        "$region,$cluster,$container,$($cni.Ec2InstanceId)"
    }
}

function getEC2Instances_FromClusters($clusterArray, $region)
{
    # Establish Column Headers
    # This needs to be in same order as field display in getEC2Instances

    $output = "Region,Cluster,ContainerInstance,Ec2InstanceID"

    $output

    foreach($cluster in $clusterArray)
    {
        getEC2Instances $cluster $region
    }
}

function getECSContainerEC2InstanceInfo([String]$cluster, $region)
{
    foreach($containerArn in (getECSContainerInstances $cluster $region))
    {
        $containerInstance = getContainerInstanceName($containerArn)
        $json = Get-ECSContainerInstanceDetail -Cluster $cluster -ContainerInstance $containerInstance -Region $region |
            ConvertTo-Json -Depth 10 | ConvertFrom-Json

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
# End AWSPowerShell_ECSFunctions.ps1
#
################################################################################