#PS C:\Users\PKuchulakanti> $m ="snavnmgttadm001","snavnmsgtems003","snavnapptesb002"
#PS C:\Users\PKuchulakanti> $m
#snavnmgttadm001
#snavnmsgtems003
#snavnapptesb002
#PS C:\Users\PKuchulakanti> icm $m {Get-Service|select-object Name |where {$_ -match "tib"}}

# Before we start, let's see how much we know
# and see if there are some things we might not realize.....

$a = "sna1", "sna2", "sna3"
$a | Get-Member

$a1 = sna1, sna2, sna3
$a1 | Get-Member

$a2 = 1, 2, 3
$a2 | Get-Member

$a3 = "one", 2, 3
$a3 | Get-Member

$a4 = "1", 2, 3
$a4 | Get-Member

$a5 = 1, "2", 3
$a5 | Get-Member

# Off to the Side

$a3 | get-member | Out-Host -Paging

# Output CmdLets

Get-Command -verb Out

Get-Service | Out-Clipboard
Get-Service | Out-Default
Get-Service | Out-GridView
Get-Service | Out-String | GEt-Member
Get-Service | Get-Member
# Back to our program

$a3.GetType()

$a3[0].GetType()
$a3[1].GetType()
$a3[2].GetType()

$a4[0].GetType()
$a4[1].GetType()
$a4[2].GetType()

$a5[0].GetType()
$a5[1].GetType()
$a5[2].GetType()

$a6 = "1" + 2 + 3
$a6 | Get-Member
$a6

$a7 = 1 + "2" + 3
$a7 | Get-Member
$a7

# More fun with get-Member

Get-Service | Get-Member
Get-Service | Get-Member -Force
Get-Service | Get-Member -MemberType Property
Get-Service | Get-Member -MemberType Method
Get-Service | Get-Member -MemberType 
Get-Service | Format-List -Property *

Get-Service | Get-TypeName
Get-Service | Get-TypeName -FullName


# A couple more side trips

ipconfig | Get-Member


# Some
get-help get-member
# All
get-help get-member -Full

# Tasteful selections
get-help get-member -Parameter Force
get-help get-member -Parameter *
get-help get-member -Examples


# Commanding understanding

get-command
get-command -CommandType Cmdlet
get-command -CommandType Function
get-Command -Noun Service
get-command -Verb Get
get-command -Verb Stop
get-command | Sort-Object Module
get-command *.exe
get-command *.bat
get-command *.cmd
get-command *.ps1
get-command gacutil.exe | select-object path

        
# And now back to our guest, Pavan

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



# Providers

Get-PSProvider



