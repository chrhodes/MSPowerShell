#region Thank You for being a nagging voice

# It is not where I want it !!!

# C:\Program Files (x86)\EyeOnLife\SqlInformationAgent\SQLInformationAgent.exe
# installUtil SQLInformationAgent.dll
# C:\Windows\Microsoft.Net\Framework\v4.0.30319

# PS C:\windows\Microsoft.NET\Framework\v4.0.30319> get-history

  # Id CommandLine
  # -- -----------
   # 1 installutil
   # 2 cd 'C:\windows\Microsoft.NET\Framework\v4.0.30319'
   # 3 $iu = Insallutil.exe
   # 4 $iu = InstallUtil.exe
   # 5 (dir .\InstallUtil.exe).GetType()
   # 6 (dir .\InstallUtil.exe).GetMember()
   # 7 dir .\InstallUtil.exe | Get-Member
   # 8 (dir .\InstallUtil.exe).FullName
   # 9 $iu = (dir .\InstallUtil.exe).FullName
  # 10 $iu
  # 11 & $iu

# PS C:\windows\Microsoft.NET\Framework\v4.0.30319> cd 'C:\Program Files (x86)\EyeOnLife\SQLInformationAgent'
# PS C:\Program Files (x86)\EyeOnLife\SQLInformationAgent> & $iu SqlInformationAgent.exe
# Microsoft (R) .NET Framework Installation utility Version 4.0.30319.18010
# Copyright (C) Microsoft Corporation.  All rights reserved.


# Running a transacted installation.

# Beginning the Install phase of the installation.
# See the contents of the log file for the C:\Program Files (x86)\EyeOnLife\SQLInformationAgent\SqlInformationAgent.exe as
# sembly's progress.
# The file is located at C:\Program Files (x86)\EyeOnLife\SQLInformationAgent\SqlInformationAgent.InstallLog.
# Installing assembly 'C:\Program Files (x86)\EyeOnLife\SQLInformationAgent\SqlInformationAgent.exe'.
# Affected parameters are:
   # logtoconsole =
   # logfile = C:\Program Files (x86)\EyeOnLife\SQLInformationAgent\SqlInformationAgent.InstallLog
   # assemblypath = C:\Program Files (x86)\EyeOnLife\SQLInformationAgent\SqlInformationAgent.exe
# Installing service SQLInformationDataLoadService...
# Service SQLInformationDataLoadService has been successfully installed.
# Creating EventLog source SQLInformationDataLoadService in log Application...

# The Install phase completed successfully, and the Commit phase is beginning.
# See the contents of the log file for the C:\Program Files (x86)\EyeOnLife\SQLInformationAgent\SqlInformationAgent.exe as
# sembly's progress.
# The file is located at C:\Program Files (x86)\EyeOnLife\SQLInformationAgent\SqlInformationAgent.InstallLog.
# Committing assembly 'C:\Program Files (x86)\EyeOnLife\SQLInformationAgent\SqlInformationAgent.exe'.
# Affected parameters are:
   # logtoconsole =
   # logfile = C:\Program Files (x86)\EyeOnLife\SQLInformationAgent\SqlInformationAgent.InstallLog
   # assemblypath = C:\Program Files (x86)\EyeOnLife\SQLInformationAgent\SqlInformationAgent.exe

# The Commit phase completed successfully.

# The transacted install has completed.

#endregion

#region Gotchas

# Good sessions on PluralSight - PowerShell Gotchas - Jim Christopher


#region Even Nothing is Something

$psversiontable

# Pop Quiz !!!
# How do I run a different version of PowerShell

#region Answer
powershell.exe -version 2
#endregion

# Pop Quiz !!!
# Name two ways to iterate on things in PowerShell (hint *for*)

#region Answer

# the foreach statement
# the foreach-object Cmdlet

#endregion

#region Deep Dive

$f = Get-ChildItem;
$f
foreach( $file in $f ) { "Name is $file" }

Clear-Host

$f | foreach-object { "Name is $_" }

cls

<#
    What is happening here? 
#>
$a

# RHODES - WAKE UP -  REMEMBER TO FIX n+ $PROFILE

<#
   What will you see?
#>
foreach( $item in $a ) { "something? nothing?" }

<# 
    What will you see?
#>
$a | foreach-object { "something? nothing?" }

<#
    What?  $a has no value but foreach-object will iterate it once?

    What exactly is going on here?
#>

cls

<#
    
    check it out - this may help clarify the difference:
#>
function get-nothing {}
function get-null { $null }


<#
    the first function returns nothing - literally no value at all;
    the second function returns a null reference
#>

get-nothing | foreach-object { "nothing" }
get-null | foreach-object { "null value" }


<#
    the best part, in PowerShell v2, both statements behaved identically
    but in PowerShell v3, the behavior of the foreach statement (not the cmdlet)
    changed!    
#>

#... run this part of the demo in powershell -version 2
$psversiontable
$a
foreach( $item in $a ) { "iteration" }
$a | foreach-object { "iteration" }

# ... back in powershell -version 3
<#
    one strategy you can employ is to use PowerShell in strict mode.
    Strict mode puts best-practice restrictions on your code and
    will prevent you from using undefined variables:
#>
set-strictmode -version 3
$a

# note the error in attempting to access an undefined variable
$a | foreach-object { "iteration" }

#endregion

#endregion

#region Everything is a Pipeline and Everything may go down the pipe

# demo prep...
<#
cd $home
rmdir backups -force -recurse
ipmo pscx
function global:copy-toExpensiveOffsiteStorage{ process { $input | %{ "`$`$`$ copying $_ to expensive offsite storage `$`$`$" } } }

cls
#>

function get-numbers {
    1
    2
    3
    return 4
    5
}

# Pop Quiz !!!
# What will we see?  Why.  Extra credit for talking a lot about why.

get-numbers

<#
    PowerShell functions are gabby - that is, they really like to output things to the pipeline
    
    this is a remarkably unique behavior - not many other languages exist that
    consider a value on its own to be output from a function

    but this is a huge part of what makes powershell so awesome.  it lets you create little 
    tools that fit together into more complex pipelines that accomplish amazing things

    e.g.
#>

get-numbers | sort -Descending
get-numbers | sort -Descending | clip
notepad

cls

<#
    however this can lead to some really bad side-effects if you're not careful

    if you call a cmdlet that returns an object from your function, that object
    will be sent to the pipeline, and the results could be anything from 
    unanticipated errors to system failure

    for instance, look at this function
#>

#region Deeper Dive

function backup-project{
    push-location $home
    mkdir backups -force
    write-zip ./documents/project "./backups/mybackup$((get-date).ticks).zip"
    pop-location
}

<#
    pretty straightforward: create a backup folder, then zip a project folder into that backup folder

    So, what gets output from this function?  if you're familiar with the PSCX module you
    probably know that write-zip will output the FileInfo for the created zip file
#>

backup-project

<#
    but LO!  the output from backup-project includes the created backups folder as well...

    the mkdir (new-item) cmdlet outputs the item it creates to the pipeline.  in this sense,
    the mkdir is "polluting" our pipeline with output we don't want.

    Image what would happen if we used backup-project in this pipeline below
    the entire backup directory could potentially be sent to our expensive Azure
    storage, which isn't really what we intend
#>

backup-project | copy-toExpensiveOffsiteStorage

cls

#endregion

# Pop Quiz !!!
# What are some ways to make things go away?

#region Answer

# Store in a variable
# Output to out-null
# Redirect to different output stream

#endregion

#region Deep Dive

<#
    so what do we do?  we need to create the backup folder if it doesn't exist.

    well, we need to do something with the output of mkdir, and we have a few options

    first, we can pipe the output to the out-null cmdlet:
#>

mkdir tmp | out-null

#out-null simply swallows anything coming out of the current pipeline

# you can also "capture" the output in a local variable to prevent it from getting into the pipeline:
$d = mkdir tmp2

# for instance, here is how you would fix our backup-project function:
#@
function backup-project{
    push-location $home
    mkdir backups -force | out-null
    write-zip ./documents/project "./backups/mybackup$((get-date).ticks).zip"
    pop-location
}
#@

#now the fuction only outputs the zip file object, and not the backup directory
backup-project | copy-toExpensiveOffsiteStorage

#endregion

#endregion

#region Express Yourself

# prep:
<#
function obliterate-computer{ 
    sleep -second 1.4
    write-host -fore green  @'

                                   /\\|//'
                                    (O X)    
     ---------------------------ooO--(_)--Ooo----------------------------
   
'@
    write-host  @'

      @@@@@@@@   @@@@@@    @@@@@@   @@@@@@@   @@@@@@@   @@@ @@@  @@@@@@@@  
     @@@@@@@@@  @@@@@@@@  @@@@@@@@  @@@@@@@@  @@@@@@@@  @@@ @@@  @@@@@@@@  
     !@@        @@!  @@@  @@!  @@@  @@!  @@@  @@!  @@@  @@! !@@  @@!       
     !@!        !@!  @!@  !@!  @!@  !@!  @!@  !@   @!@  !@! @!!  !@!       
     !@! @!@!@  @!@  !@!  @!@  !@!  @!@  !@!  @!@!@!@    !@!@!   @!!!:!    
     !!! !!@!!  !@!  !!!  !@!  !!!  !@!  !!!  !!!@!!!!    @!!!   !!!!!:    
     :!!   !!:  !!:  !!!  !!:  !!!  !!:  !!!  !!:  !!!    !!:    !!:       
     :!:   !::  :!:  !:!  :!:  !:!  :!:  !:!  :!:  !:!    :!:    :!:       
      ::: ::::  ::::: ::  ::::: ::   :::: ::   :: ::::     ::     :: ::::  
      :: :: :    : :  :    : :  :   :: :  :   :: : ::      :     : :: ::   
                                                                           
'@ -fore darkred

    write-host -fore green  @'
       
     ---------------------------ooO-------Ooo----------------------------

'@
sleep -second 4
}
#>
# demo starts here #

# powershell understands basic expressions
5-3
'hello' + ' world!'


<# 
    and as discussed in the intro to this module, powershell lets you 
    combine expressions and commands into pipelines
#>

'this is some data' | out-file ./data.txt

<#
    In this case the expression result provides input to the out-file
    cmdlet, which writes its input to the file data.txt
#>
get-content ./data.txt

<#
    If we look at the help for out-file, we can see that this input
    is actually just another cmdlet parameter named InputObject
#>
get-help out-file -param *

<#
-InputObject <psobject>
    Specifies the objects to be written to the file. Enter a variable that contains the o
    bjects or type a command or expression that gets the objects.

    Required?                    false
    Position?                    named
    Default value
    Accept pipeline input?       true (ByValue)
    Accept wildcard characters?  false
    
    The help for InputObject is marked as accepting pipeline input, which means we 
    can rewrite our previous example like so:
#>
cls

out-file ./data.txt -inputobject 'this is some other data'
get-content ./data.txt

#note the content of the file is updated

<#
    so it should come as no surprise that if we use an expression to provide 
    input to out-file, the data file will contain the results of our expression
#>
1+1 | out-file ./data.txt
get-content ./data.txt

# the file contains the value 2

<#
    and it should follow that we can reorganize our pipeline input into the 
    argument for out-file:
#>
out-file ./data.txt -inputobject 1+1
get-content ./data.txt

# wait - the file contains the expression itself, 1+1... what gives?

<#
    this is an order-of-operations thing...
    
    in the first case, our pipeline consists of two segments: 1+1 which is set to pipe to out-file.
    when this case executes, the 1+1 is resolved first since it represents a complete pipeline segment
    and it's output is requried as input before the out-file cmdlet can be executed.  Here, '1 + 1' is 
    viewed to be an expression since it's a complete statement
    
    in the second case, the out-file cmdlet is the only segment in the pipeline.  when this executes,
    powershell doesn't notice the '1 + 1' until it's parsing parameter values for the cmdlet.  by that point,
    it isn't looking for expressions to evaluate, it's looking for objects or values.  so rather than resolve
    '1 + 1' as an expression, PowerShell "helps you out" by interpreting '1 + 1' as a string.
#>
cls

<#
    this may seem odd, but it makes a lot of sense.  
    
    consider this example:
#>
out-file ./neverExecuteTheseCommands.txt -inputobject obliterate-computer

<#
    Assume that I've got an obliterate-computer cmdlet that I can use to ... well, obliterate the 
    contents of my computer.
    
    I obviously don't want to EXECUTE the obliterate-comptuer cmdlet in this case, I'm just
    making a note of it in a file.  NOT interpreting parameters as expressions is the safest 
    option for powershell to use.
#>

<#
    So what do you do when you need PowerShell to evaluate a parameter?  Easy - just enclose it in parentheses ()
#>

out-file ./data.txt -inputobject (1+1)
get-content ./data.txt

<#
    this forces PowerShell to look at the '1+1' FIRST, evaluating it as an expression before 
    even considering the outer context of the out-file cmdlet.       
#>

# The parens than contain any arbitrarily complex powershell statement, including cmds and pipelines
out-file ./neverExecuteTheseCommands.txt -inputobject (obliterate-computer)

#endregion

#endregion

#region Extending PowerShell
#
# SnapIns (Cmdlet)
#
# Modules (Cmdlet)
#
# ExternalScripts
#
# Functions/Filters
#
# Happy Fingers

#region Demo

Get-Command -CommandType All

$AllCommandsHT = @{}
Get-Command -CommandType All | ForEach-Object {$AllCommandsHT[$_.CommandType] += 1}
$AllCommandsHT

Get-Command -CommandType Alias
Get-Command -CommandType Application
Get-Command -CommandType Cmdlet
Get-Command -CommandType Filter
Get-Command -CommandType Function
Get-Command -CommandType ExternalScript

Get-Command |
    Format-Table -Property Verb, Noun, PSSnapin, Module

#endregion

#region SnapIns

# Add-PSSnapin
# Get-PSSnapin
# Export-Console

Get-PSSnapin
Get-PSSnapin -Registered
Export-Console CurrentSnapins
notepad CurrentSnapins.psc1

#endregion

#region Modules

# Get-Module
# Import-Module

Get-Module

# In 3.0 Modules autoload

$env:PSModulePath
($env:PSModulePath).Split(";")

#endregion

# Scripts

# Functions

#endregion
