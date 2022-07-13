################################################################################
#
# AWSPowerShell_CWFunctions.ps1
#
################################################################################

# Get-CWAlarm
# Get-CWAlarmForMetric
# Get-CWAlarmHistory
# Get-CWAnomalyDetector
# Get-CWDashboard
# Get-CWDashboardList

# Get-CWInsightRule
# Get-CWInsightRuleReport

# Get-CWMetricData
#
# SYNTAX
#   Get-CWMetricData 
#   -UtcEndTime <System.DateTime> 
#   [-MaxDatapoint <System.Int32>] 
#   -MetricDataQuery <Amazon.CloudWatch.Model.MetricDataQuery[]>
#   [-ScanBy <Amazon.CloudWatch.ScanBy>] 
#   -UtcStartTime <System.DateTime>        
#   [-LabelOptions_Timezone <System.String>]
#   [-EndTime <System.DateTime>]
#   [-NextToken <System.String>] 
#   [-StartTime <System.DateTime>]
#   [-Select <System.String>]
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

# $startTime = (Get-Date).AddDays(-1)
# $endTime = Get-Date

# $startDate
# $endDate

# $utcStartTime=[System.DateTime]::UtcNow.AddDays(-1)
# $utcEndTime=[System.DateTime]::UtcNow

# $utcStartTime
# $utcEndTime

# $dimFilter2 = [PSCustomObject]@{
#     Name = "ClusterName"
#     Value = "daco-prod02"
# }


# $dimFilter=[Amazon.CloudWatch.Model.Dimension]::new()
# $dim.Name="ClusterName"
# $dim.Value="daco-prod02"

# Get-CWMetricData -Region $region -UtcStartTime $startDate -UtcEndTime $endDate | more

# Get-CWMetricStatistics
#     -Region $region -UtcStartTime $startDate -UtcEndTime $endDate
#     -MetricName "CPUUtilization" 
#     -Dimension $dimFilter
#     -Namespace "AWS/ECS"
#     -Period 60
#     -Statistic "Average"

# Get-CWMetricList
#
# SYNTAX
#   Get-CWMetricList 

#   [[-Namespace] <System.String>] 
#   [[-MetricName] <System.String>]
#   [[-Dimension] <Amazon.CloudWatch.Model.DimensionFilter[]>]
#   [-RecentlyActive <Amazon.CloudWatch.RecentlyActive>]
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

# NB. Super long list

# Get-CWMetricList -Region $region

# Get-CWMetricList -Region $region -Namespace "AWS/EC2" | Select-Object * -Unique | more

# Dimensions   MetricName                 Namespace
# ----------   ----------                 ---------
# {InstanceId} StatusCheckFailed_Instance AWS/EC2
# {InstanceId} NetworkPacketsIn           AWS/EC2
# {InstanceId} StatusCheckFailed_System   AWS/EC2
# {InstanceId} NetworkPacketsOut          AWS/EC2
# {InstanceId} CPUUtilization             AWS/EC2
# {InstanceId} EBSWriteOps                AWS/EC2
# {InstanceId} EBSReadBytes               AWS/EC2
# {InstanceId} EBSIOBalance%              AWS/EC2
# {InstanceId} NetworkIn                  AWS/EC2
# {InstanceId} StatusCheckFailed          AWS/EC2
# {InstanceId} DiskWriteBytes             AWS/EC2
# {InstanceId} MetadataNoToken            AWS/EC2
# {InstanceId} NetworkOut                 AWS/EC2
# {InstanceId} DiskReadOps                AWS/EC2
# {InstanceId} DiskWriteOps               AWS/EC2
# {InstanceId} EBSByteBalance%            AWS/EC2
# {InstanceId} EBSWriteBytes              AWS/EC2
# {InstanceId} EBSReadOps                 AWS/EC2
# {InstanceId} DiskReadBytes              AWS/EC2
# {InstanceId} CPUCreditBalance           AWS/EC2
# {InstanceId} CPUSurplusCreditsCharged   AWS/EC2
# {InstanceId} CPUCreditUsage             AWS/EC2
# {InstanceId} CPUSurplusCreditBalance    AWS/EC2
# {}           NetworkOut                 AWS/EC2
# {}           DiskReadBytes              AWS/EC2
# {}           NetworkIn                  AWS/EC2
# {}           EBSReadBytes               AWS/EC2
# {}           EBSReadOps                 AWS/EC2
# {}           EBSWriteBytes              AWS/EC2
# {}           MetadataNoToken            AWS/EC2
# {}           DiskReadOps                AWS/EC2
# {}           EBSWriteOps                AWS/EC2
# {}           CPUUtilization             AWS/EC2
# {}           DiskWriteBytes             AWS/EC2
# {}           DiskWriteOps               AWS/EC2

# Get-CWMetricList -Region $region -Namespace "AWS/ECS" | Select-Object * -Unique | more

# Dimensions                 MetricName        Namespace
# ----------                 ----------        ---------
# {ClusterName}              MemoryUtilization AWS/ECS
# {ServiceName, ClusterName} MemoryUtilization AWS/ECS
# {ClusterName}              CPUReservation    AWS/ECS
# {ServiceName, ClusterName} CPUUtilization    AWS/ECS
# {ClusterName}              MemoryReservation AWS/ECS
# {ClusterName}              CPUUtilization    AWS/ECS

# Get-CWMetricList -Region $region -Namespace "AWS/ECS" `
#     -MetricName "CPUUtilization" | more

# Get-CWMetricList -Region $region -Namespace "AWS/ECS" `
#     -MetricName "CPUUtilization" | Select-Object -Expand Dimensions | more
# $dimFilter = @{}
# $dimFilter.Add("ClusterName", "daco-prod02")
# $dimFilter | Get-Type
# $dimFilter | Get-Member
# $dimFilter

# $dimFilter2 = [PSCustomObject]@{
#     Name = "ClusterName"
#     Value = "daco-prod02"
# }

# $dimFilter2

# Get-CWMetricList -Region $region -Namespace "AWS/ECS" `
#     -MetricName "CPUUtilization" -Dimension $dimFilter2 |
#     Select-Object -Expand Dimensions | more

#     Get-CWMetricList -Region $region -Namespace "AWS/ECS" `
#      -Dimension $dimFilter2 |
#     Select-Object -Expand Dimensions | more    



# Here is a (hopefully complete) list of Namespaces
# AWS/AmplifyHosting
# AWS/ApiGateway
# AWS/ApplicationELB
# AWS/Athena
# AWS/AutoScaling
# AWS/Backup
# AWS/CertificateManager
# AWS/Cognito
# AWS/Config
# AWS/DDoSProtection
# AWS/DevOps-Guru
# AWS/DMS
# AWS/DocDB
# AWS/DynamoDB
# AWS/EBS
# AWS/EC2
# AWS/EC2Spot
# AWS/ECR
# AWS/ECS
# AWS/ECS/ManagedScaling
# AWS/EFS
# AWS/ElastiCache
# AWS/ElasticBeanstalk
# AWS/ELB
# AWS/ES
# AWS/Events
# AWS/Firehose
# AWS/GlobalAccelerator
# AWS/Inspector
# AWS/Kafka
# AWS/Kinesis
# AWS/Lambda
# AWS/Logs
# AWS/NATGateway
# AWS/NetworkELB
# AWS/PrivateLinkEndpoiâ€¦
# AWS/QuickSight
# AWS/RDS
# AWS/RDS
# AWS/Redshift
# AWS/S3
# AWS/SES
# AWS/SNS
# AWS/SQS
# AWS/SSM-RunCommand
# AWS/States
# AWS/Textract
# AWS/TransitGateway
# AWS/Usage
# AWS/VPN
# CWAgent
# ECS/ContainerInsights
# System/Linux
# WAF

# 
# Get-CWMetricStatistic
#
# SYNTAX
#   Get-CWMetricStatistic
#
#   [-Namespace] <System.String>
#   [-MetricName] <System.String> 
#   [[-Dimension] <Amazon.CloudWatch.Model.Dimension[]>]
#   -UtcEndTime <System.DateTime> 
#   [-ExtendedStatistic <System.String[]>] 
#   -Period <System.Int32>
#   -UtcStartTime <System.DateTime> 
#   [-Statistic <System.String[]>]
#   [-Unit <Amazon.CloudWatch.StandardUnit>]
#   [-EndTime <System.DateTime>] 
#   [-StartTime <System.DateTime>]
#   [-Select <System.String>]
#   [-PassThru <System.Management.Automation.SwitchParameter>]
#   [-EndpointUrl <System.String>] [-Region <System.Object>] [-AccessKey
#     <System.String>] [-SecretKey <System.String>] [-SessionToken        
#     <System.String>] [-ProfileName <System.String>] [-ProfileLocation   
#     <System.String>] [-Credential <Amazon.Runtime.AWSCredentials>]      
#     [-NetworkCredential <System.Management.Automation.PSCredential>]    
#     [<CommonParameters>]

# $utcStartTime=[System.DateTime]::UtcNow.AddDays(-30)
# $utcEndTime=[System.DateTime]::UtcNow
# $utcStartTime=[System.DateTime]::UtcNow.AddDays(-30)
# $utcEndTime=[System.DateTime]::UtcNow

# $utcStartTime
# $utcEndTime

# $dimFilter2 = [PSCustomObject]@{
#     Name = "ClusterName"
#     Value = "daco-prod02"
# }


# $dimFilter=[Amazon.CloudWatch.Model.Dimension]::new()
# $dimFilter.Name="ClusterName"
# $dimFilter.Value="daco-prod02"

# $dimFilter=[Amazon.CloudWatch.Model.Dimension]::new()
# $dimFilter.Name="InstanceId"
# $dimFilter.Value="i-57542c92"

# Get-CWMetricData -Region $region -UtcStartTime $startDate -UtcEndTime $endDate | more

# $outputMaximum = Get-CWMetricStatistics `
#     -UtcStartTime $utcStartTime -UtcEndTime $utcEndTime `
#     -MetricName "CPUUtilization" `
#     -Dimension $dimFilter `
#     -Namespace "AWS/EC2" `
#     -Period 60 `
#     -Statistic "Maximum" `
#     -Region $region

# $outputAverage = Get-CWMetricStatistics `
#     -UtcStartTime $utcStartTime -UtcEndTime $utcEndTime `
#     -MetricName "CPUUtilization" `
#     -Dimension $dimFilter `
#     -Namespace "AWS/EC2" `
#     -Period 60 `
#     -Statistic "Average" `
#     -Region $region   
    
# $outputMinimum = Get-CWMetricStatistics `
#     -UtcStartTime $utcStartTime -UtcEndTime $utcEndTime `
#     -MetricName "CPUUtilization" `
#     -Dimension $dimFilter `
#     -Namespace "AWS/EC2" `
#     -Period 60 `
#     -Statistic "Minimum" `
#     -Region $region    
    
# $outputALL = Get-CWMetricStatistics `
#     -UtcStartTime $utcStartTime -UtcEndTime $utcEndTime `
#     -MetricName "CPUUtilization" `
#     -Dimension $dimFilter `
#     -Namespace "AWS/EC2" `
#     -Period 3600 `
#     -Statistic @("Minimum","Average","Maximum") `
#     -Region $region    

# $outputMaximum.Datapoints | Select-Object -Property Maximum > maximum.txt
# $outputAverage.Datapoints | Select-Object -Property Average > average.txt
# $outputMinimum.Datapoints | Select-Object -Property Minimum > minimum.txt

# $outputAll.Datapoints | sort-object -Property Timestamp |
#      Select-Object -Property @("TimeStamp", "Minimum", "Average", "Maximum") | 
#      ConvertTo-Csv > i-57542c92.csv

function getCW_EC2_CPUUtilization([string]$ec2InstanceId, [string]$region, [System.DateTime]$utcStartTime, [System.DateTime]$utcEndTime)
{
    # $utcStartTime=[System.DateTime]::UtcNow.AddDays(-40)
    # $utcEndTime=[System.DateTime]::UtcNow

    $dimFilter=[Amazon.CloudWatch.Model.Dimension]::new()
    $dimFilter.Name="InstanceId"
    $dimFilter.Value=$ec2InstanceId  
    
    $outputALL = Get-CWMetricStatistics `
    -UtcStartTime $utcStartTime -UtcEndTime $utcEndTime `
    -MetricName "CPUUtilization" `
    -Dimension $dimFilter `
    -Namespace "AWS/EC2" `
    -Period 3600 `
    -Statistic @("Minimum","Average","Maximum") `
    -Region $region 

    $dataPoints = $outputAll.Datapoints | sort-object -Property Timestamp 

    foreach($dp in $dataPoints)
    {
        $output = "$region,$($ec2InstanceId)"
        $output += ",$($dp.TimeStamp.ToUniversalTime()),$($dp.Minimum),$($dp.Average),$($dp.Maximum)"

        $output
    }

    # |
    #     Select-Object -Property @("TimeStamp", "Minimum", "Average", "Maximum")     
}

function getCW_ECS_Cluster_CPUUtilization([string]$cluster, [string]$region, [System.DateTime]$utcStartTime, [System.DateTime]$utcEndTime)
{
    $dimFilter=[Amazon.CloudWatch.Model.Dimension]::new()
    $dimFilter.Name="ClusterName"
    $dimFilter.Value=$cluster  
   
    $outputALL = Get-CWMetricStatistics `
    -UtcStartTime $utcStartTime -UtcEndTime $utcEndTime `
    -MetricName "CPUUtilization" `
    -Dimension $dimFilter `
    -Namespace "AWS/ECS" `
    -Period 3600 `
    -Statistic @("Minimum","Average","Maximum") `
    -Region $region 

    $dataPoints = $outputAll.Datapoints | sort-object -Property Timestamp 

    foreach($dp in $dataPoints)
    {
        $output = "$region,$($cluster)"
        $output += ",$($dp.TimeStamp.ToUniversalTime()),$($dp.Minimum),$($dp.Average),$($dp.Maximum)"

        $output
    }    
}

function getCW_ECS_Service_CPUUtilization([string]$cluster, [string]$service, [string]$region, [System.DateTime]$utcStartTime, [System.DateTime]$utcEndTime)
{
    $clusterFilter=[Amazon.CloudWatch.Model.Dimension]::new()
    $clusterFilter.Name="ClusterName"
    $clusterFilter.Value=$cluster  

    # $clusterFilter

    $serviceFilter=[Amazon.CloudWatch.Model.Dimension]::new()
    $serviceFilter.Name="ServiceName"
    $serviceFilter.Value=$service

    # $serviceFilter

    $dimFilter = @($clusterFilter, $serviceFilter)

  
    $outputALL = Get-CWMetricStatistics `
    -UtcStartTime $utcStartTime -UtcEndTime $utcEndTime `
    -MetricName "CPUUtilization" `
    -Dimension $dimFilter `
    -Namespace "AWS/ECS" `
    -Period 3600 `
    -Statistic @("Minimum","Average","Maximum") `
    -Region $region 

    $dataPoints = $outputAll.Datapoints | sort-object -Property Timestamp 

    foreach($dp in $dataPoints)
    {
        $output = "$region,$($service)"
        $output += ",$($dp.TimeStamp.ToUniversalTime()),$($dp.Minimum),$($dp.Average),$($dp.Maximum)"

        $output
    }  
}

# Get-CWMetricStream
# Get-CWMetricStreamList
# Get-CWMetricWidgetImage
# Get-CWResourceTag

################################################################################
#
# End AWSPowerShell_CWFunctions.ps1
#
################################################################################