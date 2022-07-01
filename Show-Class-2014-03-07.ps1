# A deeper look at messing with Objects

#region First a quick review of what we know already about Select-Object and Where-Object

# Select-Object

Get-Process powershell*
Get-Process powershell* | Get-Member -MemberType Properties, Methods
Get-Process powershell* | Select-Object Name | Get-Member -MemberType Properties, Methods

# Where-Object

Get-Process powershell*

# Script block style

Get-Process | Where-Object {$_.Name -like "powershell*"}

# Comparison Statement style

Get-Process | Where-Object -Property Name -Like -Value "powershell*"

# Easy, piezy style

Get-Process powershell*

# NB. We get full objects with all Properties and Methods intact

Get-Process | Where-Object {$_.Name -like "powershell*"} | Get-Member -MemberType Properties, Methods


# Ok, what else can we do with Objects?

Get-Command -Noun object

#endregion

#region And now, Jedi stuff (Padawan learner style)

# First how does the Get-Process powershell* work?
# look at the -Name parameter

Get-Help Get-Process -Full | more    # Grrr - do from non-ISE to get paging to work!

# Ok moving on to Select-Object

# We know how to do this

Get-Process powershell*

# but only want to see

Get-Process powershell* | Select-Object Name, NPM, PM

# but, yuck, what happened to the formatting on NPM and PM??

# Rhodes says PowerShell knows KB and I know a little about expressions and statements so let's try a couple of things

Get-Process powershell* | Select-Object Name, ($_.NPM / 1KB), PM

# Bummer, what about

Get-Process powershell* | Select-Object Name, {$_.NPM / 1KB}, {$_.PM / 1MB}

# Go me.  But the $_.NPM looks lame not to mention the nn.nnnnnn format of the numbers.
# I never had this problem with bash :(

# Must be something else this sucks.....

#-Property<Object[]>
#
#Specifies the properties to select. Wildcards are permitted. 
#
#The value of the Property parameter can be a new calculated property. To create a calculated, property, use a hash table. Valid keys are:
#
#-- Name (or Label) <string>
#
#-- Expression <string> or <script block>

# Huh?

Get-Process powershell* | 
    Select-Object Name, 
        @{Name="Non-Paged Memory"; Expression={$_.NPM / 1KB}}, 
        @{Name="Paged Memory"; Expression={$_.PM / 1MB}}

# Cool, but I want more!

Get-Process powershell* | 
    Select-Object Name, 
        @{Name="Non-Paged Memory"; Expression={$_.NPM / 1KB}}, 
        @{Name="Paged Memory"; Expression={$_.PM / 1MB}} |
    Format-Table -AutoSize

# Well, that helps but seriously, so many digits after the decimal point??  I want more!!

Get-Process powershell* | 
    Select-Object Name, 
        @{Name="Non-Paged Memory"; Expression={"{0:F3}" -f ($_.NPM / 1KB)}}, 
        @{Name="Paged Memory"; Expression={"{0:F3}" -f ($_.PM / 1MB)}} |
    Format-Table -AutoSize

# Nice, what about left justified and a bit more room between columns

# Seriously, you are getting annoying, but if you must, try this

Get-Process powershell* | 
    Select-Object Name, NPM, PM |    
    Format-Table -AutoSize @{Name="Process Name"; Expression={"{0,30}" -f $_.Name}},     
        @{Name="Non-Paged Memory"; Expression={"{0:F3}" -f ($_.NPM / 1KB)}; Align="Right"}, 
        @{Name="Paged Memory"; Expression={"{0:F3}" -f ($_.PM / 1MB)}; Align="Center"} 

#endregion

#region A Bit more

# Select-Object

get-service | get-member -Force
get-service | Select-Object Name
get-service | Select-Object Name | Get-Member -force


# Where-Object

# Script block style
get-service | Where-Object {$_.Name -like "App*"}
# Comparison Statement style
get-service | Where-Object -Property Name -Like -Value "App*"

get-service | Where-Object {$_.Name -like "App*"} | get-member -force

get-service App*
(get-service winrm).ServicesDependedOn
(get-service winrm).Status


(get-service winrm).Stop()
(get-service winrm).Start()

# NB. () after methods.
# Not working, do you have priviliges?

#endregion

#region Providers


get-alias dir

# Consistent handling of hierarchical namespaces
# Examples?
#

Get-PSProvider

Get-Item
Get-Item C:\

Get-ChildItem
Get-ChildItem C:\
Get-ChildItem C:\Temp
Get-ChildItem C:\Temp\Accenture -Recurse

# Quiz

(Get-ChildItem C:\Temp\Accenture -Recurse).GetType()

# Location, location, location

Get-Alias pwd

Get-Location

Push-Location C:\temp\PSTestFiles

Get-Location

Pop-Location

Get-Alias cd

# Gotchas

# Powershell and Windows have different notions of HOME
# ~
# $HOME
#
# Be explicit don't count on ~

# Item

Get-Alias mv
Get-Alias cp
Get-Alias rm

# New home

Set-Location HKLM:\SOFTWARE
Get-Location
Get-Item
Get-Item C:\
Get-Item \
Get-ChildItem
Set-Location Adobe
Get-ChildItem -Recurse

Set-Location Variable:
Get-ChildItem

Set-Location Env:
Get-ChildItem

Set-Location Alias:
Get-ChildItem

Set-Location Function:
Get-ChildItem

# Pause, What did I just see???


Set-Location Cert:
Get-ChildItem

Set-Location C:\

#Whew!

#endregion



