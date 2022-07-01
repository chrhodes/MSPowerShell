Setting up VNC style PowerShell has become easier.
Most of the magic is the the files contained in B:\bin\powershell and sub folders

Three Key Steps

1. Ensure that B: is mapped to something that has \bin \bin\powershell

2. Tell Windows about our special profile that does all the work by pointing to a module: VNCPowerShell.psm1

Copy profile.ps1 to following locations
	C:\Windows\System32\WindowsPowerShell\v1.0
	and
	C:\Windows\SysWOW64\WindowsPowerShell\v1.0

Need Administrator privileges to do so

The profiles can live in a variety of places.  Use commands below to see what is current

NB.  If the above ws successful, you can also just run displayProfiles
which is a custom function defined in VNCPowerShell.psm1

$profile | Format-List -Force

Need to do from both 32 bit and 64 bit PowerShell
Set-ExecutionPolicy needs to be done from both, also.  If you don't Visual Studio won't be able to run scripts

PS C:\Users\crhodes> $profile | Format-List -Force

PS C:\Users\crhodes> $profile | Format-List -Force


AllUsersAllHosts       : C:\Windows\System32\WindowsPowerShell\v1.0\profile.ps1
AllUsersCurrentHost    : C:\Windows\System32\WindowsPowerShell\v1.0\Microsoft.PowerShell_profile.ps1
CurrentUserAllHosts    : C:\Users\crhodes\Documents\WindowsPowerShell\profile.ps1
CurrentUserCurrentHost : C:\Users\crhodes\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1

AllUsersAllHosts       : C:\Windows\SysWOW64\WindowsPowerShell\v1.0\profile.ps1
AllUsersCurrentHost    : C:\Windows\SysWOW64\WindowsPowerShell\v1.0\Microsoft.PowerShell_profile.ps1
CurrentUserAllHosts    : C:\Users\crhodes\Documents\WindowsPowerShell\profile.ps1
CurrentUserCurrentHost : C:\Users\crhodes\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1

3. Install Posh-Git.  This is needed if you want the fancy Posh-Git prompts

install-module posh-git -scope currentuser -force

