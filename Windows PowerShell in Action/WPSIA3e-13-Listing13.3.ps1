workflow test-restart {
   Get-CimInstance -ClassName Win32_OperatingSystem | 
   Select-Object -ExpandProperty LastBootupTime
   Restart-Computer
   Suspend-Workflow
   Get-CimInstance -ClassName Win32_OperatingSystem | 
   Select-Object -ExpandProperty LastBootupTime
} 

$actionscript = '-NonInteractive -WindowStyle Normal –NoLogo -NoProfile -NoExit -Command "& {Get-Job -Name boottime | Resume-Job}"'
$pstart =  "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"

Get-ScheduledTask -TaskName ResumeWF | Unregister-ScheduledTask -Confirm:$false

$act = New-ScheduledTaskAction -Execute $pstart -Argument $actionscript
$trig = New-ScheduledTaskTrigger -AtLogOn

Register-ScheduledTask -TaskName ResumeWF -Action $act -Trigger $trig -RunLevel Highest  

test-restart -AsJob -JobName boottime