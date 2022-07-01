param ( 
  [string] $serverFile = 'servers.txt',
  [int] $throttleLimit = 10,
  [int] $numProcesses = 5
)  
  
$gatherInformation ={ 
    param ([int] $procLimit = 5)
    @{
        Date = Get-Date
        FreeSpace = (Get-PSDrive c).Free
        PageFaults = (Get-CimInstance `
            Win32_PerfRawData_PerfOS_Memory).PageFaultsPersec
        TopCPU = Get-Process |
                 Sort-Object CPU -Descending | 
                 Select-Object -First $procLimit
        TopWS =  Get-Process | 
                 Sort-Object WS -Descending | 
                 Select-Object -First $procLimit
    }
}

$servers = Import-CSV $serverfile | 
    Where-Object { $_.Day -eq (Get-Date).DayOfWeek } |
    foreach { $_.Name }

Invoke-Command -ThrottleLimit $throttleLimit -ComputerName $servers `
       -ScriptBlock $gatherInformation `
       -ArgumentList $numProcesses  