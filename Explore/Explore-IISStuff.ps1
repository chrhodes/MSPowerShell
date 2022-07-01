# ExploreIISStuff.ps1
#  Windows Features
Import-Module ServerManager
Get-Command -Module ServerManager

# Can see and add windows features.
Get-WindowsFeature
Add-WindowsFeature

# Web Administration
Import-Module WebAdministration
Get-Command -Module WebAdministration

# IIS service
Stop-Service -Name W3SVC
Restart-Service -Name W3SVC
Start-Service -Name W3SVC

# PowerShell IIS Provider

Set-Location IIS:
dir
Get-ChildItem
Get-ChildItem -Recurse

Get-ChildItem AppPools
Get-ChildItem AppPools | Get-Member
(Get-ChildItem AppPools).Count

Get-ChildItem AppPools -Recurse

foreach($ap in (Get-ChildItem AppPools))
{
    $ap.name
}

foreach($ap in (Get-ChildItem AppPools))
{
    #$ap1 = "IIS:\AppPools\($ap.Name)"
    $ap1 = "IIS:\AppPools\" + $ap.Name
    $ap1
    (Get-Item $ap1).Attributes | Format-Table Name, Value -AutoSize
    #(Get-Item "IIS:\AppPools\($ap.Name)").Attributes | gm
    $ap | Select-Object -ExpandProperty CPU
    $ap.failure
}

$ap0 = (gci apppools)[0]


Get-ChildItem Sites
Get-ChildItem Sites | Get-Member
(Get-ChildItem Sites).Count

foreach($ap in (Get-ChildItem Sites))
{
    (Get-Item ("IIS:\Sites\" + $ap.name)).Attributes | Format-Table Name, Value
}

Get-ChildItem SssBindings

cd Sites

$obj = dir
$names = $obj | Get-Member -type property | foreach {$_.name}
$names | foreach { "$_ = $($obj.$_)" }

dir | Select-Object Bindings
Get-Item 'Default Web Site' | Select-Object *



#
Get-WebAppDomain
#
Get-WebApplication
#
Get-WebApplication

# Some output but not clear what it is tell us
Get-WebAppPoolState
Get-WebAppPoolState | Select-Object Name, Value
# Useful output
Get-WebBinding
# Useful output
Get-WebConfigFile
#
Get-WebConfiguration *
#
Get-WebConfigurationBackup
#
Get-WebConfigurationLocation
#
Get-WebConfigurationLock *
#
Get-WebConfigurationProperty *
#
Get-WebFilePath
#
Get-WebGlobalModule
#
Get-WebHandler
#
Get-WebItemState
#
Get-WebManagedModule
#
Get-WebRequest
#
Get-Website
#
Get-WebsiteState
#
Get-WebURL
#
Get-WebVirtualDirectory

# Using -ExpandProperty

Get-WebSite -Name "Default Web Site"
Get-Website -Name "Default Web Site" | Select-Object -ExpandProperty Bindings
Get-Website -Name "Default Web Site" | Select-Object -ExpandProperty Bindings | gm
Get-Website -Name "Default Web Site" | Select-Object -ExpandProperty Bindings | Select-Object -ExpandProperty Collection
Get-Website -Name "Default Web Site" | Select-Object -ExpandProperty Bindings | Select-Object -ExpandProperty Collection | gm
Get-Website -Name "Default Web Site" | Select-Object -ExpandProperty Bindings | Select-Object -ExpandProperty Collection | Select-Object -ExpandProperty Attributes
Get-Website -Name "Default Web Site" | Select-Object -ExpandProperty Bindings | Select-Object -ExpandProperty Collection | Select-Object -ExpandProperty Attributes | gm

Get-Website -Name "Default Web Site" | Select-Object -ExpandProperty Bindings | Select-Object -ExpandProperty Collection | Select-Object -ExpandProperty ChildElements

Get-Website -Name "Default Web Site" | Select-Object -ExpandProperty Bindings | Select-Object -ExpandProperty Attributes
Get-Website -Name "Default Web Site" | Select-Object -ExpandProperty Bindings | Select-Object -ExpandProperty ChildElements
Get-Website -Name "Default Web Site" | Select-Object -ExpandProperty Bindings | Select-Object -ExpandProperty Methods
Get-Website -Name "Default Web Site" | Select-Object -ExpandProperty Bindings | Select-Object Schema

Get-Website -Name "Default Web Site" | 
    Select-Object -ExpandProperty Bindings | 
    Select-Object -ExpandProperty Collection | Get-Member

# Using PSCX Extentions

Show-Tree IIS:\ -Depth 3
Show-Tree IIS:\ -Depth 6
Show-Tree IIS:\AppPools -ShowLeaf
Show-Tree IIS:\AppPools -ShowProperty

Show-Tree IIS:\AppPools\DefaultAppPool -ShowLeaf
Show-Tree IIS:\AppPools\DefaultAppPool -ShowProperty

Show-Tree 'IIS:\Sites\Default Web Site'
Show-Tree 'IIS:\Sites\Default Web Site' -Depth 6
Show-Tree 'IIS:\Sites\Default Web Site' -ShowLeaf
Show-Tree 'IIS:\Sites\Default Web Site' -ShowProperty

#Set-ItemProperty IIS:\AppPools\DefaultAppPool managedRuntimeVersion v4.0

# Take a backup of the current Web Configuration.  Provide Name.
# Goes under <WINDIR>|System32\inetsrv\Backup

Backup-WebConfiguration -Name FooBarBackup

# Can restore a previous backup with

Restore-WebConfiguration -Name FooBarBackup