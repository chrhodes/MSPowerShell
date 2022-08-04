# Install AWS PowerShell tools
# https://docs.aws.amazon.com/powershell/latest/userguide/pstools-getting-set-up-windows.html

# Run this as Administrator to install for all users
Install-Module -name AWSPowerShell.NetCore

# Run this for current user
Install-Module -name AWSPowerShell.NetCore -Scope CurrentUser

# Although PowerShell 3.0 and later releases typically load modules 
# into your PowerShell session the first time you run a cmdlet in the module, 
# the AWSPowerShell.NetCore module is too large to support this functionality. 
# You must instead explic$clstly load the AWSPowerShell.NetCore Core module 
# into your PowerShell session by running the following command.
Import-Module AWSPowerShell.NetCore

Get-Module -Name *AWS*

$MODULE = "AWSPowerShell.NetCore"

# Oh, my, there are a LOT of CmdLet's

Get-Command -Module AWSPowerShell.NetCore | ConvertTo-CSV > AWSPowerShell_NetCore_Commands.csv

# Let's just look for Get-<Noun>

Get-Verb -Module $MODULE -Verb Get

# Get the <Verb>.*ECS* CmdLet's

Get-Command -Module AWSPowerShell.NetCore -Noun *ECS*

# Ok, how bout just the Get-*ECS* CmdLet's !

Get-Command -Module AWSPowerShell.NetCore -Verb Get | Where-Object -Property Noun -Match ".*ECS.*"

Get-Command -Module AWSPowerShell.NetCore -Verb Get | Where-Object -Property Noun -Match ".*EC2.*"

Get-Command -Module AWSPowerShell.NetCore -Verb Get -Name -Match "*ECS*" 
Get-Verb -Module $MODULE -Verb Get

Get-AWSPowerShellVersion

Get-AWSPowerShellVersion -ListServiceVersionInfo

Set-AWSCredential `
    -AccessKey <ACCESSKEY> `
    -SecretKey <SecretKey> `
    -StoreAs PlatformCostsRO              

Get-AWSCredential -ListProfileDetail

Set-AWSCredential -ProfileName PlatformCostsRO
Set-AWSCredential -ProfileName PlatformCostsROStage

Remove-AWSCredentialProfile -ProfileName an-old-profile-I-do-not-need

#
# Need to specify the default region or pass it into commands
#

# Region         Name                      IsShellDefault
# ------         ----                      --------------
# af-south-1     Africa (Cape Town)        False
# ap-east-1      Asia Pacific (Hong Kong)  False
# ap-northeast-1 Asia Pacific (Tokyo)      False
# ap-northeast-2 Asia Pacific (Seoul)      False
# ap-northeast-3 Asia Pacific (Osaka)      False
# ap-south-1     Asia Pacific (Mumbai)     False
# ap-southeast-1 Asia Pacific (Singapore)  False
# ap-southeast-2 Asia Pacific (Sydney)     False
# ap-southeast-3 Asia Pacific (Jakarta)    False
# ca-central-1   Canada (Central)          False
# eu-central-1   Europe (Frankfurt)        False
# eu-north-1     Europe (Stockholm)        False
# eu-south-1     Europe (Milan)            False
# eu-west-1      Europe (Ireland)          False
# eu-west-2      Europe (London)           False
# eu-west-3      Europe (Paris)            False
# me-south-1     Middle East (Bahrain)     False
# sa-east-1      South America (Sao Paulo) False
# us-east-1      US East (N. Virginia)     False
# us-east-2      US East (Ohio)            False
# us-west-1      US West (N. California)   False
# us-west-2      US West (Oregon)          True
# us-iso-east-1  US ISO East               False
# us-iso-west-1  US ISO WEST               False
# us-isob-east-1 US ISOB East (Ohio)       False

Get-DefaultAWSRegion

Set-DefaultAWSRegion -Region us-west-2

Get-DefaultAWSRegion

Get-AWSRegion | ForEach-Object { 
    $_.Region
    Get-ECSClusterList -Region $_.Region | Measure-Object | Select-Object Count
}

$Regions = @("us-west-2", "us-east-2", "eu-west-1", "eu-central-1")

"Region           ECS ClusterCount       EC2 InstanceCount"
foreach($region in $Regions)
{
    $ecsClusterCount = Get-ECSClusterList -Region $region | Measure-Object | Select-Object Count
    $ec2InstanceCount = Get-EC2Instance -Region $region | Measure-Object | Select-Object Count

    "{0,15}         {1,5}         {2,5}" -f $region, $($ecsClusterCount.Count), $($ec2InstanceCount.Count)
}

# Region           ECS ClusterCount     EC2 InstanceCount
#       us-west-2          395                  2700
#       us-east-2            2                    27
#       eu-west-1            1                     2
#    eu-central-1          153                   905

$Regions | ForEach-Object {  }
Get-ECSClusterList -Region "us-west-2" | Measure-Object
Get-ECSClusterList -Region "us-east-2" | Measure-Object

Get-ECSClusterList -Region "eu-west-1" | Measure-Object
Get-ECSClusterList -Region "eu-central-1" | Measure-Object

Get-AWSRegion | ForEach-Object { 
    $_.Region
    Get-EC2Instance -Region $_.Region | Measure-Object | Select-Object Count
}

# PS C:\VNC\git\chrhodes\MSPowerShell\AWS> get-command Get-ECS* | sort-object -property name

# CommandType     Name                                               Version    Source
# -----------     ----                                               -------    ------
# Cmdlet          Get-ECSAccountSetting                              4.1.109    AWSPowerShell.NetCore        
# Cmdlet          Get-ECSAttributeList                               4.1.109    AWSPowerShell.NetCore        
# Cmdlet          Get-ECSCapacityProvider                            4.1.109    AWSPowerShell.NetCore        
# Cmdlet          Get-ECSClusterDetail                               4.1.109    AWSPowerShell.NetCore        
# Cmdlet          Get-ECSClusterList                                 4.1.109    AWSPowerShell.NetCore        
# Alias           Get-ECSClusters                                    4.1.109    AWSPowerShell.NetCore        
# Cmdlet          Get-ECSClusterService                              4.1.109    AWSPowerShell.NetCore        
# Cmdlet          Get-ECSContainerInstanceDetail                     4.1.109    AWSPowerShell.NetCore        
# Cmdlet          Get-ECSContainerInstanceList                       4.1.109    AWSPowerShell.NetCore        
# Alias           Get-ECSContainerInstances                          4.1.109    AWSPowerShell.NetCore        
# Cmdlet          Get-ECServiceUpdate                                4.1.109    AWSPowerShell.NetCore        
# Cmdlet          Get-ECSnapshot                                     4.1.109    AWSPowerShell.NetCore        
# Alias           Get-ECSnapshots                                    4.1.109    AWSPowerShell.NetCore        
# Cmdlet          Get-ECSService                                     4.1.109    AWSPowerShell.NetCore        
# Cmdlet          Get-ECSTagsForResource                             4.1.109    AWSPowerShell.NetCore        
# Cmdlet          Get-ECSTaskDefinitionDetail                        4.1.109    AWSPowerShell.NetCore        
# Alias           Get-ECSTaskDefinitionFamilies                      4.1.109    AWSPowerShell.NetCore        
# Cmdlet          Get-ECSTaskDefinitionFamilyList                    4.1.109    AWSPowerShell.NetCore        
# Cmdlet          Get-ECSTaskDefinitionList                          4.1.109    AWSPowerShell.NetCore        
# Alias           Get-ECSTaskDefinitions                             4.1.109    AWSPowerShell.NetCore        
# Cmdlet          Get-ECSTaskDetail                                  4.1.109    AWSPowerShell.NetCore        
# Cmdlet          Get-ECSTaskList                                    4.1.109    AWSPowerShell.NetCore        
# Alias           Get-ECSTasks                                       4.1.109    AWSPowerShell.NetCore        
# Cmdlet          Get-ECSTaskSet                                     4.1.109    AWSPowerShell.NetCore    

#Get-ECSAccountSetting

# Either spec$clsfy the profile to use

Get-ECSAccountSetting -ProfileName PlatformCostsRO

# or set the profile for the session

Set-AWSCredential -ProfileName PlatformCostsRO

# or set the default profile


Get-AWSRegion

Get-DSRegion
Get-EC2Region
Get-LSRegionList








