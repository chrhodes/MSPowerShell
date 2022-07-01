## Code for chapter 7 PowerShell in Action third edition
##  This file contains the code from the chapter body. 
##  Any individual listings are supplied in separate files
##  Code has been unwrapped so may look slightly different 
##  to that presented in the book


## 7.1 PowerShell scripts
'"Hello world"' > hello.ps1
./hello.ps1


## 7.1.1 Script execution policy
Set-ExecutionPolicy remotesigned
./hello.ps1

Set-ExecutionPolicy -Scope process remotesigned


## 7.1.2 Passing arguments to scripts
'"Hello $args"' > hello.ps1
./hello Bruce
./hello

@'
if ($args) { $name = "$args" } else { $name = "world" }
"Hello $name!"
'@ > hello.ps1
./hello
./hello Bruce

@'
param($name="world")
"Hello $name!"
'@ > hello.ps1
./hello
./hello Bruce


## 7.1.3 Exiting scripts and the exit statement
@'
function callExit { "calling exit from callExit"; exit}
CallExit
"Done my-script"
'@ > my-script.ps1
./my-script.ps1

powershell "'Hi there'; exit 17"
echo %ERRORLEVEL%


## 7.1.4 Scopes and scripts
$x = 1

@'
function lfunc { $x = 100; $script:x = 10 ; "lfunc: x = $x"}
lfunc
"my-script:x = $x"
'@ > my-script.ps1

./my-script.ps1
"global: x = $x"


## Simple libraries: including one script from another
@'
"Setting x to 22"
$x = 22
'@ > my-script.ps1

. ./my-script
$x

function set-x ($x) {$x = $x}
. set-x 3
$x


## 7.2 Writing advanced functions and scripts
## 7.2.1 Specifying script and function attributes
function x {
[CmdletBinding()] 
param($a, $b)
"a=$a b=$b args=$args"
}

x 1 2 3 4


## The HelpUri property
Get-Command Get-Service | Format-List help*


## The SupportsPaging property
see test-paging.ps1


## The SupportsShouldProcess property
see stops-processingusingWMI.ps1

notepad
Stop-ProcessUsingWMI notepad -Whatif

Get-Process notepad | Format-Table name,id -auto
Stop-ProcessUsingWMI notepad -Confirm


## 7.2.3 The OutputType attribute
see listing7.1.ps1

(Test-OutputType -asString).GetType().FullName
(Test-OutputType -asInt).GetType().FullName
(Test-OutputType -lie).GetType().FullName

(Get-Command Test-OutputType).OutputType

(Get-Command Get-Service).OutputType | Format-List


## 7.2.4 Specifying parameter attributes
## The Mandatory property

function Test-Mandatory
{
param ( [Parameter(Mandatory=$true)] $myParam)
$myParam
}

Test-Mandatory


## The Position property
function Test-Position
{
param (
[parameter()] $p1 = 'p1 unset',
$p2 = 'p2 unset'
)
"p1 = '$p1' p2='$p2'"
}

Test-Position one two

function Test-Position
{
param (
[parameter(Position=0)] $p1 = 'p1 unset',
$p2 = 'p2 unset'
)
"p1 = '$p1' p2='$p2'"
}

Test-Position one two
Test-Position one -p2 two


## The ParameterSetName property
see listing7.2.ps1

Get-Command Test-ParameterSets -Syntax
Test-ParameterSets -p1 one -p4 four
Test-ParameterSets -p1 one -p3 three -p4 four
Test-ParameterSets -p2 two -p3 three
Test-ParameterSets -p2 two
Test-ParameterSets -p2 two -p3 three -p4 four
Test-ParameterSets -p1 one -p2 two -p3 three -p4 four


## The ValueFromPipeline property
function Test-ValueFromPipeline
{
param([Parameter(ValueFromPipeline = $true)] $x)
process { $x }
}

Test-ValueFromPipeline 123
123 | Test-ValueFromPipeline


## The ValueFromPipelineByPropertyName property
function Test-ValueFromPipelineByPropertyName
{
param(
[Parameter(ValueFromPipelineByPropertyName=$true)]
$DayOfWeek
)
process { $DayOfWeek }
}

Get-Date | Test-ValueFromPipelineByPropertyName

Test-ValueFromPipelineByPropertyName (Get-Date)

Test-ValueFromPipelineByPropertyName ((Get-Date).DayOfWeek)


## The ValueFromRemainingArguments property
function vfraExample
{
param (
$First,
[parameter(ValueFromRemainingArguments=$true)]
$Rest
)
"First is $first rest is $rest"
}

vfraExample 1 2 3 4
vfraExample 1 -Rest 2 3 4
vfraExample 1 -Rest 2,3,4


## The HelpMessage property
function helpMessageExample
{
param (
[parameter(Mandatory=$true,
HelpMessage='An array of path names.')]
[string[]]
$Path
)
"Path: $path"
}

helpMessageExample


## 7.2.5 Creating parameter aliases with the Alias attribute
function Test-ParameterAlias
{
param (
[alias('CN')]
$ComputerName
)
"The computer name is $ComputerName"
}

Test-ParameterAlias -ComputerName foo
Test-ParameterAlias -CN foo
Test-ParameterAlias -com foo

function Test-ParameterAlias
{
param (
[alias('CN')]
$ComputerName,
[switch] $Compare
)
"The computer name is $ComputerName,
compare=$compare"
}

Test-ParameterAlias -Com foo
Test-ParameterAlias -CN foo


## 7.2.6 Parameter validation attributes
function allowNullExample
{
param
(
[parameter(Mandatory=$true)]
[AllowNull()]
$objectToTest
)
$objectToTest -eq $null
}

function validateNotNullExample
{
param
(
[ValidateNotNull()]
$objectToTest
)
$objectToTest -eq $null
}

function validateCountExample
{
param (
[int[]] [ValidateCount(2,2)] $pair
)
"pair: $pair"
}

validateCountExample 1
validateCountExample 1,2
validateCountExample 1,2,3

function validateLengthExample
{
param (
[string][ValidateLength(8,10)] $username
)
$userName
}

function validatePatternExample
{
param (
[ValidatePattern('^[a-z][0-9]{1,7}$')]
[string] $hostName
)
$hostName
}

validatePatternExample b123
validatePatternExample c123456789

function validateRangeExample
{
param (
[int[]][ValidateRange(1,10)] $count
)
$count
}

validateRangeExample 1,2,3,22,4

function validateSetExample
{
param (
[ValidateSet('red', 'blue', 'green')]
[ConsoleColor] $color
)
$color
}

validateSetExample red
validateSetExample cyan

function validateScriptExample
{
param (
[int] [ValidateScript({$_ % 2 -eq 0})] $number
)
$number
}

validateScriptExample 2
validateScriptExample 3


## 7.3 Dynamic parameters and dynamicParam
see dynamicParameterexample.ps1

dynamicParameterExample -dp1 13 -Path c:\
dynamicParameterExample -dp1 13 -Path HKLM:\


## 7.4 Cmdlet default parameter values
## 7.4.1 Creating default values

$PSDefaultParameterValues= @{
'Get-Process:Name'='powershell'}

Get-Process
Get-Process -Name *
Get-Process -Name winword

$PSDefaultParameterValues

$PSDefaultParameterValues= @{
'Get-Service:Name'='BITS'}
$PSDefaultParameterValues

$PSDefaultParameterValues.Add('Get-Process:Name', 'PowerShell')
$PSDefaultParameterValues.Add('Get-CimInstance:ClassName', 'Win32_ComputerSystem')
$PSDefaultParameterValues


## 7.4.2 Modifying default values
$PSDefaultParameterValues.Remove('Get-CimInstance:ClassName')
$PSDefaultParameterValues

$PSDefaultParameterValues['Get-Service:Name'] = 'LanmanWorkstation'
$PSDefaultParameterValues

$PSDefaultParameterValues['Get-Service:Name']

$PSDefaultParameterValues.Add('Disabled', $true)
$PSDefaultParameterValues['Disabled']=$true

$PSDefaultParameterValues['Disabled']=$false
$PSDefaultParameterValues

$PSDefaultParameterValues.Remove('Disabled')
$PSDefaultParameterValues.Clear()


## 7.4.3 Using scriptblocks to determine default value
$PSDefaultParameterValues=@{
'Format-Table:AutoSize'= {if ($host.Name –eq 'ConsoleHost'){$true}}
}

$PSDefaultParameterValues.Add(
'Invoke-Command:ScriptBlock',
{{Get-EventLog -Log Application}})
$PSDefaultParameterValues


## 7.5 Documenting functions and scripts
## 7.5.3 Comment-based help
function abc ([int] $x, $y)
{
<#
.SYNOPSIS
This is my abc function
.DESCRIPTION
This function is used to demonstrate writing doc
comments for a function.
#>
}