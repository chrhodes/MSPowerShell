############################################################
#
# Windows PowerShell in Action Chapter 1
#
# 1.1 What is PowerShell
#
# 1.2 Soul of a new language
#
# 1.3 Brushing up on objects
#
# 1.4 Up and running with PowerShell
#
# 1.5 Dude! Where's my code?
#
############################################################

# Teasers

"Hello World!"

dir $env:windir\*.log |
    Select-String -List error |
    Format-Table path, linenumber -AutoSize

([xml] (New-Object net.webclient).DownloadString("http://blogs.msdn.com/powershell/rss.aspx")).rss.channel.item |
Format-Table title, link

[void][reflection.assembly]::LoadWithPartialName("System.Windows.Forms")
$frm = New-Object Windows.Forms.Form
$frm.Text = "PowerShell Study Group"
$btn = New-Object Windows.Forms.Button
$btn.text = "Punch Me!"
$btn.Dock="fill"
$btn.Add_Click({$frm.Close()})
$frm.Controls.Add($btn)
$frm.Add_Shown({$frm.Activate()})
$frm.ShowDialog()

# 1.1 What is PowerShell

# Passes Objects not strings
# Large set of built-in commands with consitent interface and syntax
# All commands use same parser - not different for each.

# 1.2 Soul of a new language

# 1.2.2 Leveraging .NET

Get-Date
Get-Date "November 22, 1956"
(Get-Date "November 22, 1956").DayOfWeek

(dir file1.txt).LastWriteTime -gt (dir file2.txt)

# 1.3 Brushing up on objects

Get-Date
Get-Date | Get-Member

"Hello World" | Get-Member

4.4 | Get-Member
4 | Get-Member

# d = new Date()
# d = new Date("November 22, 1956")
# d.DayOfWeek()

# Verb-Noun
# Get-* - gets an object

Get-Process | Get-Member
Get-Service
Get-Help Get-Process


# 1.4 Up and running with PowerShell

# Command Editing Features
# Play with
# Left/Right Arrows
# Ctrl-Left/Right
# Home
# End
# Up/Down
# Insert
# Delete
# Backspace
# Tab (files, methods. properties, history (#))

# Learn and use ISE

# 1.5 Dude!  Where's my code?


##############################
# Fundamentals
##############################
# 
# Commands (CmdLets)
# Verb-Noun
#
##############################
#
# Get-Help
# Get-Member
# Get-Item
# Get-ChildItem
# Get-Content
# Get-Alias
# Update-Help
#
#############################

# 1.5.2 Basic Expressions and variables

# Evaluate Expressions

2+2
(3+3)*7
22/7

# File Redirection & Aliases

2+2 > foo.txt
Get-Content foo.txt
type foo.txt
Get-Help type
Get-Alias type
Get-Alias

# Declare Variables
$f
$f = 2+2
$f
$f * 9

##########
# QUIZ
##########

$f | Get-Member

##########
# End
##########

$d = dir
$d
$d[3]

##########
# QUIZ
##########

$d | gm

##########
# End
##########

Get-Alias dir
Get-ChildItem | Get-Member

# Add Types

2+2
"Hello" + "World"
"One" + 2
1,2,3 + 4,5,6
"Count with me: " + 1,2,3

# 1.5.3 Processing Data

# Sorting Objects

Get-Alias sort

Get-ChildItem
Get-ChildItem | Sort-Object
Get-ChildItem | Sort-Object -Descending
Get-ChildItem | Sort-Object LastWriteTime -Descending

# Selecting properties of objects

##########
# QUIZ
##########

$a = dir | sort -Property length | select-object -First 2
$a
##########
# ???
##########

$a
$a[0]

##########
# ???
##########

$a = dir | sort -Property length | Select-Object -First 2 -Property Directory

$a

##########
# End
##########

# Processing with the ForEach-Object cmdlet

$a = dir | sort -Property length -Descending |
    Select-Object -First 1 |
    ForEach-Object { $_.DirectoryName }

$a

$total = 0
dir | Foreach-Object {$total += $_.Length}
$total

Get-Alias foreach

$total = 0
dir | foreach {$total += $_.Length}
$total

##############################
# Fundamentals
##############################
#
# Variables
#
##############################
#
# $_
#
##############################

# Processing other kinds of data

dir | sort -Descending length | select -First 3

##########
# QUIZ
##########

Get-Process | sort -Descending ws | select -First 3

##########
# ???
##########

Get-Process | Get-Member

Get-WmiObject -Class Win32_LogicalDisk |
    sort -Descending freespace |
    select -First 2 |
    Format-Table -AutoSize deviceid, freespace

##########
# End
##########

# 1.5.4 Flow-Control Statements

##############################
# Fundamentals
##############################
#
# Flow-Control
#
##############################
#
# if
# switch
# for
# foreach
# while
#
##############################

##############################
# Fundamentals
##############################
#
# Comparison
#
##############################
#
# -lt
# -le
# -gt
# -ge
# -eq
#
##############################

$i=0
while ($i++ -lt 10) { if ($i % 2) {"$i is odd"}}

$i=0
while ($i++ -lt 10)
{ 
    if ($i % 2)
    {
        "$i is odd"
    }
}

foreach ($i in 0 .. 10) { if ($i %2) {"$i is odd"}}

##########
# QUIZ
##########

##########
# ???
##########

1 .. 20 | foreach { if ($_ % 2) {"$_ is odd"}}

##########
# End
##########

# Put this in a file, Hello.ps1

param($name = "World")
"Hello $name, how are you?"

function hello
{
    param($name = "Frank")
    "Greetings $name, how drunk are you?"
}

hello
hello Chris

# 1.5.6 Remoting and the Universal Execution Model

# Get version of program

Get-Command notepad.exe | gm
(Get-Command notepad.exe) | Get-Member
(Get-Command notepad.exe).FileVersionInfo
(Get-Command notepad.exe).FileVersionInfo.ProductVersion

$a = "C:\temp\PSTestFiles\HelloWorld.exe"
Get-Command $a
(Get-Command $a) | Get-Member | fl
(Get-Command $a) | Get-Member | ft
(Get-Command $a) | Select-Object *
(Get-Command $a) | Get-Member
(Get-Command notepad.exe).FileVersionInfo | gm
(Get-Command notepad.exe).FileVersionInfo.ProductVersion

# This progression gets us to a script that compares versions of programs
# on a list of machines

# First just get the info

(gcm mmc.exe).FileVersionInfo.ProductVersion

$c1 = (gcm mmc.exe).FileVersionInfo.ProductVersion
$c1

$m1 = "TRON"
$m2 = "PARTHENON"
$m3 = "MATRIX"
$m4 = "VNCDC1"
$m5 = "VNCDC2"
$m6 = "EMPRESS"
$m7 = "WORF"

$m8 = "CRHODES-L1"
$m9 = "CBILSLAND-L1"
$m9 = "VNCGraphics1"
$m10 = "CHRDevServer"

# Elevated Prompt
#winrm quickconfig -q

Invoke-Command $m8 { (gcm mmc.exe).FileVersionInfo.ProductVersion }
Invoke-Command $m9 { (gcm mmc.exe).FileVersionInfo.ProductVersion }
Invoke-Command 10.0.8.19 { (gcm mmc.exe).FileVersionInfo.ProductVersion }
Invoke-Command $m8 { (gcm mmc.exe).FileVersionInfo.ProductVersion } | Select-Object PSComputerName

##########
# QUIZ
##########

##########
# ???
##########

Invoke-Command $m7 { (gcm mmc.exe).FileVersionInfo.ProductVersion } | gm

$mlist = $m1, $m2,  $m3, $m4, $m5
$mlist = $m8, $m9, $m10, $m8

icm $m8 { Get-Date; Get-Date } | Select-Object PSComputerName

ping
icm $mlist { (gcm mmc.exe).FileVersionInfo.ProductVersion  | gm}

icm $mlist {
    (gcm mmc.exe).FileVersionInfo.ProductVersion |
        where { $_ -notmatch '6\.2' }
}

icm $mlist {
    (gcm mmc.exe).FileVersionInfo.ProductVersion |
        #where { $_ -notmatch '6\.2' }
        Select-Object @{N="Computer" ; E={$_.PSComputerName}},
                        @{N="MMC Version" ; E={$_}} # | Format-Table -Auto
     
} | Format-Table -Auto

icm $mlist {
    (gcm mmc.exe).FileVersionInfo.ProductVersion |
        #where { $_ -notmatch '6\.2' }
        Select-Object PSComputerName
     
} | Format-Table -Auto

Get-ADGroup -filter 'Name -like "FAHQ-DL-Middleware Services"' | 
    Get-ADGroupMember | 
    Format-Table -Property name, SamAccountName

    # Display Installed Modules

Get-Module

# List Available Modules

Get-Module -ListAvailable

# List All Available Modules

Get-Module -ListAvailable -All

# Import a module so it can be used

Import-Module <moduleName>

# Get all commands in module

Get-Command -Module <moduleName>

# Create some files showing what commands are in each (loaded) module

foreach($mod in (Get-Module | Select-Object Name))
{
    $nm = $mod.Name
    Get-Command -module $mod.Name > C:\temp\PS-$nm.txt
}