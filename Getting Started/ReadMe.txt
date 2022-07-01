Copy profile.ps1 to following locations
	C:\Windows\System32\WindowsPowerShell\v1.0
	and
	C:\Windows\SysWOW64\WindowsPowerShell\v1.0
	and
	C:\Program Files\PowerShell\7\profile.ps1

Need Administrator privileges to do so

The profiles can live in a variety of places.  Use this to see what is current

$profile | Format-List -Force

Need to do from both 32 bit and 64 bit PowerShell and PowerShell 7
Set-ExecutionPolicy needs to be done from both, also.  If you don't Visual Studio won't be able to run scripts

PS C:\Users\crhodes> $profile | Format-List -Force

PS C:\Users\crhodes> $profile | Format-List -Force

64 bit

AllUsersAllHosts       : C:\Windows\System32\WindowsPowerShell\v1.0\profile.ps1
AllUsersCurrentHost    : C:\Windows\System32\WindowsPowerShell\v1.0\Microsoft.PowerShell_profile.ps1
CurrentUserAllHosts    : C:\Users\crhodes\Documents\WindowsPowerShell\profile.ps1
CurrentUserCurrentHost : C:\Users\crhodes\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1

32 bit

AllUsersAllHosts       : C:\Windows\SysWOW64\WindowsPowerShell\v1.0\profile.ps1
AllUsersCurrentHost    : C:\Windows\SysWOW64\WindowsPowerShell\v1.0\Microsoft.PowerShell_profile.ps1
CurrentUserAllHosts    : C:\Users\crhodes\Documents\WindowsPowerShell\profile.ps1
CurrentUserCurrentHost : C:\Users\crhodes\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1

PowerShell 7

AllUsersAllHosts       : C:\Program Files\PowerShell\7\profile.ps1
AllUsersCurrentHost    : C:\Program Files\PowerShell\7\Microsoft.PowerShell_profile.ps1
CurrentUserAllHosts    : C:\Users\crhodes\Documents\PowerShell\profile.ps1
CurrentUserCurrentHost : C:\Users\crhodes\Documents\PowerShell\Microsoft.PowerShell_profile.ps1