# If in VS Code, import module
Import-Module AWSPowerShell.NetCore

#
# Need to specify the profile to use
#

Set-AWSCredential -ProfileName PlatformCostsRO

#
# Need to specify the default region or pass it into commands
#

Set-DefaultAWSRegion -Region us-west-2

#
# Get the list of Clusters (in the region)
#

Get-ECSClusterList

#
# Set the cluster(s) to explore
#

$CLUSTER = "noae-sbx01"
$CLUSTER = "daco-prod02"

#
# Cluster Info
#

# default

Get-ECSClusterDetail | ConvertTo-Json -Depth 5

# Note only shows object

Get-ECSClusterDetail -Cluster $CLUSTER

Get-ECSClusterDetail -Cluster $CLUSTER | ConvertTo-Json -Depth 5 | ConvertFrom-Json | Select-Object -Expand Clusters | Select-Object ClusterName, RunningTasksCount 

Get-ECSClusterDetail -Cluster $CLUSTER -Include ATTACHMENTS -Depth 5
Get-ECSClusterDetail -Cluster $CLUSTER -Include CONFIGURATIONS -Depth 5
Get-ECSClusterDetail -Cluster $CLUSTER -Include SETTINGS -Depth 5
Get-ECSClusterDetail -Cluster $CLUSTER -Include STATISTICS-Depth 5
Get-ECSClusterDetail -Cluster $CLUSTER -Include TAGS | ConvertTo-Json -Depth 5

#
# Get the Services for the specified cluster
#

Get-ECSClusterService -Cluster $CLUSTER
Get-ECSClusterService -Cluster $CLUSTER | Measure-Object -Line

$SERVICE = "noae-sbx01/notification"
$SERVICE = "dc-filter"

#
# Get info on specified service for specified cluster
#

Get-ECSService -Cluster $CLUSTER -Service $SERVICE | ConvertTo-Json -Depth 10

#
# Get the Tasks for the specified cluster
#

Get-ECSTaskList -Cluster $CLUSTER
Get-ECSTaskList -Cluster $CLUSTER | measure-object -Line

#
# Set the Task to explore
#

$TASK = "00b559e2e6e943b8a14726084a172043"
$TASK = "noae-sbx01/00b559e2e6e943b8a14726084a172043"
$TASK = "daco-prod02/005ba476fa2946589c93d098ea8c763b"

$tasks = @(Get-ECSTaskList -Cluster $CLUSTER)
$taskLines = $tasks -split "`n"

foreach($line in $taskLines)
{
    $tn = getTaskName($line)
    #$tn
    Get-ECSTaskDetail -Cluster $CLUSTER -Task $tn | ConvertTo-Json -Depth 5
}

Get-ECSTaskDetail -Cluster $CLUSTER -Task $TASK | ConvertTo-Json -Depth 5
Get-ECSTaskDetail -Cluster $CLUSTER -Task $TASK | ConvertTo-Json -Depth 5 | ConvertFrom-Json

#
# Get the Containers for the specified cluster
#

Get-ECSContainerInstanceList -Cluster $CLUSTER 
Get-ECSContainerInstanceList -Cluster $CLUSTER | Measure-Object -Line

#
# Set the Container to explore
#

$CONTAINERINSTANCE = "0b560e913071410ebfe287f3f3f1c9dc" # noae-sbx01
$CONTAINERINSTANCE = "33c6615150c3405f806a9a6633e8f6f5" # daco-prod02



function getContainerInstanceInfo([String]$cluster)
{
    $containers = @(Get-ECSContainerInstanceList -Cluster $cluster)
    $containerLines = $containers -split "`n"

    "Getting ContainerInstance Info for: $cluster"    

    foreach($line in $containerLines)
    {
        $cin = getContainerInstanceName($line)
        #$cin
        $json = Get-ECSContainerInstanceDetail -Cluster $cluster -ContainerInstance $cin | ConvertTo-Json -Depth 5 | ConvertFrom-Json
        $json | Select-Object -Expand ContainerInstances | 
            Select-Object CapacityProviderName, Ec2InstanceId, PendingTasksCount, RunningTasksCount   
    }
}

getContainerInstanceInfo $CLUSTER | Format-Table

#
# Uber Loops across Clusters
#

function getAllClusterContainerInstanceInfo()
{
    $clusters = @(Get-ECSClusterList)
    $clusterLines = $clusters -split "`n"

    foreach($line in $clusterLines)
    {
        $cn = getClusterName($line)
        #$cn
        getContainerInstanceInfo $cn | Format-Table
    }
}

getAllClusterContainerInstanceInfo


Get-ECSContainerInstanceDetail -Cluster $CLUSTER -ContainerInstance $CONTAINERINSTANCE | ConvertTo-Json -Depth 5

#
# Get the list of TaskFamilies
#
# And Definitions
#

Get-ECSTaskDefinitionFamilyList

Get-ECSTaskDefinitionList

#
# Set the TaskDefinition to explore
#

$TASKDEFINITION = "DockerCleanup-Task:1"
$TASKDEFINITION = "daco-prod02-filebeat-daemon:5"

Get-ECSTaskDefinitionDetail -TaskDefinition $TASKDEFINITION | ConvertTo-Json -Depth 5


Get-ECSTaskSet -Cluster $CLUSTER

#
# Get the list of Capacity Providers
#

Get-ECSCapacityProvider | ConvertTo-Json -Depth 5

# Get One specific provider

Get-ECSCapacityProvider -CapacityProvider "noae-sbx01" | ConvertTo-Json -Depth 5


Get-ECSCapacityProvider | ConvertTo-Json -Depth 5

# Not sure how to set TargetType.  Found this somewhere

Get-ECSAttributeList -Cluster $CLUSTER -TargetType "container-instance" | ConvertTo-Json -Depth 5

# Play around with EC2

# Gets ALL the EC2 Intances

$INSTANCE = "i-0c6ab266aa48d8116"
Get-EC2Instance

Get-EC2Instance -InstanceId $INSTANCE | ConvertTo-Json -Depth 10

Get-EC2AvailabilityZone

Get-EC2CapacityReservationUsage
Get-EC2CapacityReservationFleet
Get-EC2InstanceStatus

