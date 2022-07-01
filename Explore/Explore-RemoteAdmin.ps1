$gatherInformation = {
    @{
        Date = Get-Date
        FreeSpace = (Get-PSDrive c).Free
        PageFaults = (Get-WmiObject Win32_PerfRawData_PerfOS_Memory).PageFaultsPerSec
        TopCPU = Get-Process | sort CPU -desc | select -First 5 | format-list
        TopWS = Get-Process | sort -desc WS | select -First 5 | Format-List
    }
}

$gatherDiskInfo = 
{
    Get-WMIObject Win32_LogicalDisk -filter "DriveType=3"  | 
        Select DeviceID, VolumeName, `
        @{Name="Size(GB)";Expression={"{0:N1}" -f($_.size/1gb)}}, `
        @{Name="Freespace(GB)";Expression={"{0:N1}" -f($_.freespace/1gb)}} |
        format-table
}

$gatherProcessorInfo =
{
    Get-WmiObject Win32_Processor |
        Select Name, DeviceID |
        format-table
}

$gatherOSInfo =
{
    Get-WMIObject Win32_OperatingSystem |
        Select Name, CSDVersion, OSArchitecture, Version, ServicePackMajorVersion, ServicePackMinorVersion
}

$gatherNetworkAdapterInfo =
{
    Get-WmiObject Win32_NetworkAdapter -filter "AdapterTypeID=0" | 
        Select AdapterType, MACAddress, NetConnectionID |
        format-table
}

$gatherNetworkAdapterConfigurationInfo =
{
    Get-WmiObject Win32_NetworkAdapterConfiguration -filter "IPEnabled=1" | 
        Select DHCPEnabled, IPAddress, DNSHostName, DNSServerSearchOrder, DefaultIPGateway, MACAddress |
        format-list
}

$gatherServiceInfo =
{
    Get-WmiObject Win32_Service |
        Select Name, DisplayName, Started, StartName, State, PathName
}


#Invoke-Command  vncdc1 $gatherInformation

$ServerList = "C:\users\crhodes\Desktop\bin\serverlist.txt"
$ServerListCSV = "C:\users\crhodes\Desktop\bin\serverlist.csv"

Get-Content $ServerList
Invoke-Command (Get-Content $ServerList) $gatherInformation

$gatherInfo2 = {
    @{
        Date = Get-Date
        Host = $env:COMPUTERNAME
        PS = (Get-Host).Version
    }
}

Invoke-Command ltweb04v $gatherInfo2

Invoke-Command vncdc1, vncdc2 $gatherInfo2

Invoke-Command (Get-Content $ServerList) $gatherInfo2

Write-Host (Get-Content $ServerList)

$servers = Import-CSV $ServerListCSV |
    where { $_.Day -eq (Get-Date).DayOfWeek } |
    foreach { $_.Name }

Invoke-Command $servers $gatherInfo2

$password = ConvertTo-SecureString "PASSWORDGOESHERE" -AsPlainText -Force
$password
$tstcreds = New-Object System.Management.Automation.PSCredential("tstlifeint\crhodes",$password)

$tstcreds = Get-Credential

Invoke-Command (Get-Content $ServerList) -Credential $tstcreds $gatherInformation
Invoke-Command (Get-Content $ServerList) -Credential $tstcreds $gatherInfo2

$iisInfo = {
    "********************"
    "Get-WebAppDomain"
    "********************`n"
    
    Get-WebAppDomain

    "********************"
    "Get-WebApplication"
    "********************`n"

    Get-WebApplication

    "********************"
    "Get-WebBinding"
    "********************`n"

    Get-WebBinding

    "********************"
    "Get-WebConfigurationLocation"
    "********************`n"

    Get-WebConfigurationLocation

    "********************"
    "Get-Website"
    "********************`n"

    Get-Website
}

Invoke-Command $iisInfo
