################################################################################
#
# AWSPowerShell_As_Functions.ps1
#
################################################################################

Set-StrictMode -Version Latest

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

function getAutoScalingGroupInfo([string]$asGroup, [string]$region)
{
    $asg = Get-ASAutoScalingGroup -AutoScalingGroupName $asGroup -Region $region

    $output = "$region,$($asg.AutoScalingGroupName)"
    $output += ",$($asg.DefaultCooldown)"
    $output += ",$($asg.DesiredCapacity)"
    $output += ",$($asg.MaxSize)"
    $output += ",$($asg.MinSize)"
    $output += ",$($asg.PredictedCapacity)"
    $output += ",$($asg.WarmPoolSize)"
    $output += ",$($asg.DefaultCooldown)"

    $output
}

function getAutoScalingGroupInfo_FromInstances([string[]]$asInstances, [string]$region)
{
    $header = "Region,AutoScalingGroupName"
    $header += ",DefaultCooldown"
    $header += ",DesiredCapacity"
    $header += ",MaxSize"    
    $header += ",MinSize"
    $header += ",PredictedCapacity"
    $header += ",WarmPoolSize"
    $header += ",DefaultCooldown"

    $header

    $i = 0

    foreach($asi in $asInstances)
    {
        getAutoScalingGroupInfo $asi $region

        # Need to rate limit as Get-ASAutoScalingGroup returns errors (not seen)

        if(0 -eq ++$i % 50)
        {
            Write-Error "Sleeping for 30 seconds.  Processed $i"
            Start-Sleep -Seconds 30
            Write-Error "Continuing"
        }
    }
}
function getAutoScalingInstances([String]$region)
{
    # Get-ASAutoScalingGroup -Region $region | Get-Member
    # $json = Get-ASAutoScalingGroup -Region $region | ConvertTo-Json -Depth 5
    @(Get-ASAutoScalingInstance -Region $region) | ForEach-Object {$_.InstanceId}
}

function getASAutoScalingInstanceInfo([string]$asInstance, [string]$region)
{
    try
    {
        $asi = Get-ASAutoScalingInstance -InstanceId $asInstance -Region $region

        $output = "$region,$($asi.AutoScalingGroupName)"
        $output += ",$($asi.AvailabilityZone)"
        $output += ",$($asi.HealthStatus)"
        $output += ",$($asi.InstanceId)"
        $output += ",$($asi.InstanceType)"
        $output += ",$($asi.LifecycleState)"
        $output += ",$($asi.ProtectedFromScaleIn)"
        $output += ",$($asi.WeightedCapacity)"
    }
    catch 
    {
        $output = "Error processing $asInstance"
    }
    finally
    {
        $output
    }
}

function getASAutoScalingInstanceInfo_FromInstances([string[]]$asInstances, [string]$region)
{
    $header = "Region,AutoScalingGroupName"
    $header += ",AvailabilityZone"
    $header += ",HealthStatus"
    $header += ",InstanceId"    
    $header += ",InstanceType"
    $header += ",LifeCycleState"
    $header += ",ProtectedFromScaleIn"
    $header += ",WeightedCapacity"

    $header

    $i = 0

    foreach($asi in $asInstances)
    {
        getASAutoScalingInstanceInfo $asi $region

        # Need to rate limit as Get-ASAutoScalingInstance returns errors

        if(0 -eq ++$i % 50)
        {
            Write-Error "Sleeping for 30 seconds.  Processed $i"
            Start-Sleep -Seconds 30
            Write-Error "Continuing"

        }
    }
}

################################################################################
#
# End AWSPowerShell_AS_Functions.ps1
#
################################################################################