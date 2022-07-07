################################################################################
#
# AWSPowerShell_AsFunctions.ps1
#
################################################################################


# Get-ASAccountLimit
# Get-ASAdjustmentType

# Get-ASAutoScalingGroup
#
# SYNTAX
#
# Get-ASAutoScalingGroup 
#   [[-AutoScalingGroupName] <System.String[]>]
#   [-Filter <Amazon.AutoScaling.Model.Filter[]>] 
#   [-MaxRecord <System.Int32>]
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

# Get-ASAutoScalingInstance
#
# SYNTAX
#
# Get-ASAutoScalingInstance
#   [[-InstanceId] <System.String[]>]
#   [-MaxRecord <System.Int32>]
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

# Get-ASAutoScalingNotificationType
# Get-ASInstanceRefresh
# Get-ASLaunchConfiguration
# Get-ASLifecycleHook
# Get-ASLifecycleHookType
# Get-ASLoadBalancer
# Get-ASLoadBalancerTargetGroup
# Get-ASMetricCollectionType
# Get-ASNotificationConfiguration
# Get-ASPolicy
# Get-ASPredictiveScalingForecast

# Get-ASPScalingPlan
# Get-ASPScalingPlanResource
# Get-ASPScalingPlanResourceForecastData
# Get-ASScalingActivity
# Get-ASScalingProcessType
# Get-ASScheduledAction
# Get-ASTag
# Get-ASTerminationPolicyType
# Get-ASWarmPool

function getAutoScalingGroups([String]$region)
{
    # Get-ASAutoScalingGroup -Region $region | Get-Member
    # $json = Get-ASAutoScalingGroup -Region $region | ConvertTo-Json -Depth 5
    @(Get-ASAutoScalingGroup -Region $region) | ForEach-Object {$_.AutoScalingGroupName}
}

function getAutoScalingGroupInfo($asGroup, $region)
{
    $asg = Get-ASAutoScalingGroup -AutoScalingGroupName $asGroup -Region $region

    $output = $asg.AutoScalingGroupName
    $output += ",$($asg.DefaultCooldown)"
    $output += ",$($asg.DesiredCapacity)"
    $output += ",$($asg.MaxSize)"
    $output += ",$($asg.MinSize)"
    $output += ",$($asg.PredictedCapacity)"
    $output += ",$($asg.WarmPoolSize)"
    $output += ",$($asg.DefaultCooldown)"

    $output
}

function getAutoScalingInstances([String]$region)
{
    # Get-ASAutoScalingGroup -Region $region | Get-Member
    # $json = Get-ASAutoScalingGroup -Region $region | ConvertTo-Json -Depth 5
    @(Get-ASAutoScalingInstance -Region $region) | ForEach-Object {$_.InstanceId}
}

function getASAutoScalingInstanceInfo($asInstance, $region)
{
    $asi = Get-ASAutoScalingInstance -InstanceId $asInstance -Region $region

    $output = $asi.AutoScalingGroupName
    $output += ",$($asi.AvailabilityZone)"
    $output += ",$($asi.HealthStatus)"
    $output += ",$($asi.InstanceId)"
    $output += ",$($asi.InstanceType)"
    $output += ",$($asi.LifecycleState)"
    $output += ",$($asi.ProtectedFromScaleIn)"
    $output += ",$($asi.WeightedCapacity)"

    $output
}

function getASAutoScalingInstanceInfo_FromInstances($asInstances, $region)
{
    $header = "AutoScalingGroupName"
    $header += ",AvailabilityZone"
    $header += ",HealthStatus"
    $header += ",InstanceId"    
    $header += ",InstanceType"
    $header += ",LifeCycleState"
    $header += ",ProtectedFromScaleIn"
    $header += ",WeightedCapacity"

    $header

    foreach($asi in $asInstances)
    {
        getASAutoScalingInstanceInfo $asi $region
    }
}


################################################################################
#
# End AWSPowerShell_AsFunctions.ps1
#
################################################################################