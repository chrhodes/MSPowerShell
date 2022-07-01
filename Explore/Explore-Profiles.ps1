# There are Six PowerShell Profiles
#
# Different results from CurrentHost depending if run from console or ISE
#
# Current User, Current Host - Console
# Current User, Current Host - ISE
# Current User, All Hosts

# All Users, Current Host - Console
# All Users, Current Host - ISE
# All Users, All Hosts

# NB.
# A Windows PowerShell profile (any one of the six) is simply a Windows PowerShell script. 
# It has a special name, and it resides in a special place, but it is simply a script.

# https://devblogs.microsoft.com/scripting/understanding-the-six-powershell-profiles/

$profile

$profile | Get-Member

$profile | Get-Member -MemberType NoteProperty | Get-Member

$profile | Get-Member -MemberType Noteproperty | select name | get-member


$profile | Get-Member -MemberType Noteproperty | select name | foreach-object {$_.Name}

$profile | Get-Member -MemberType NoteProperty | Select-Object -Property Name, MemberType

$profile | Format-List
$profile | Format-List -Force

$profile | Format-List a*
$profile | Format-List a* -Force

# Test to see if profile exists

Test-Path $profile  # Default is Current User, Current Host

Test-path $profile.AllUsersAllHosts

Test-Path $profile.AllUsersCurrentHost

Test-Path $profile.CurrentUserAllHosts

Test-path $profile.CurrentUserCurrentHost

# Create a new profile

New-item –type file –force $profile

New-Item -type file -Force $profile.AllUsersAllHosts
New-Item -type file -Force $profile.AllUsersCurrentHost
New-Item -type file -Force $profile.CurrentUserAllHosts
New-Item -type file -Force $profile.CurrentUserCurrentHost

# Handy to add these to profile.  See VNCPowerShell.psm1

function displayProfiles()
{   
    Write-Status "PowerShell Host Info"
    $Host

    $hostNames = @($profile | Get-Member -MemberType Noteproperty | Select-Object name)

    foreach ($h in $hostNames) { checkHostProfile $h}
}

function checkHostProfile([string] $hostName)
{
    Write-Status $hostName Cyan
    $profile.$hostName

    $result = Test-Path $profile.$hostName

    if ($result -eq "true")
    {
        Write-Status "Exists" Green
    }
    else
    {
        Write-Status "Does Not Exist" Red
    }

    ""
}