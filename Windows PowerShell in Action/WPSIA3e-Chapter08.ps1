## Code for chapter 8 PowerShell in Action third edition
##  This file contains the code from the chapter body. 
##  Any individual listings are supplied in separate files
##  Code has been unwrapped so may look slightly different 
##  to that presented in the book


## 8.2 Module basics
Get-Command -Noun Module* | Format-Wide -Column 3


## 8.3.1 Finding modules on the system
Get-Module -ListAvailable | where { $_.path -match "System32" }

Get-Module -ListAvailable PSWorkflow | Format-List


## 8.3.2 Loading a module
Get-Module
Get-CimInstance -ClassName Win32_OperatingSystem
Get-Command Get-WinEvent
Working with modules 279
Get-Help Start-Transcript
Get-Module

## Loading a module by name
Import-Module psdiagnostics

Get-Module PSDiagnostics | Format-List
Get-Command -Module PSDiagnostics
(Get-Module psdiag*).exportedfunctions

Remove-Module PSDiagnostics

Import-Module $PSHOME/modules/PSDiagnostics/PSDiagnostics

Remove-Module PSDiagnostics


## Tracing module loads with -Verbose
Import-Module PSDiagnostics -Verbose


## Imports and exports
Import-Module PSDiagnostics -Verbose -Function Enable-PSTrace


## 8.4 Writing script modules
## 8.4.1 A quick review of scripts
see counter.ps1 - Listing 8.1

. .\counter.ps1
Get-Command *-count

Get-Count
Get-Count

Reset-Count
Get-Count

Get-Command setIncrement

setIncrement 7
Get-Count
Get-Count

Get-Variable count, increment

Remove-Item -Verbose variable:count,variable:increment,function:Reset-Count, function:Get-Count,function:setIncrement


## 8.4.2 Turning a script into a module
copy .\counter.ps1 .\counter.psm1 -Force -Verbose
Import-Module .\counter.psm1
Get-Module counter
Get-Module counter | Format-List
Get-Command -Module counter

Get-Count
Get-Count
Get-Count

$count
$increment

$count = 100
Get-Count

Reset-Count
Get-Count

Remove-Module counter

Get-Count


## 8.4.3 Controlling member visibility with Export-ModuleMember
see counter1.psm1 - Listing 8.2
Import-Module .\counter1.psm1
Get-Command *-Count

Get-Command setIncrement
Remove-Module counter1


## Controlling what variables and aliases are exported
see counter2.psm1 -  Listing 8.3

Import-Module .\counter2.psm1
Get-Command *-Count
setIncrement 10

$count
$increment
Get-Alias reset


## 8.4.4 Installing a module
## Manual install

($ENV:PSModulePath -split ';')[0]

$mm = ($ENV:PSModulePath -split ';')[0]
New-Item -Path $mm/Counter2 -ItemType Directory
Copy-Item -Path .\counter2.psm1 -Destination $mm\Counter2
Get-Module -ListAvailable Counter2 | Format-List name, path
Import-Module -Verbose counter2


## Module folders
Get-ChildItem -Path 'C:\Program Files\WindowsPowerShell\Modules\Pester'
Get-Module -ListAvailable Pester

Import-Module -Name Pester -RequiredVersion 3.4.0


## PowerShellGet
Get-Command -Module PowerShellGet | Format-Wide -Column 3

Get-PSRepository | Format-List
Find-Module -Repository PSGallery

Find-Module -Repository PSGallery -Name Pscx
Install-Module -Name Pscx
Get-Module -ListAvailable pscx


## Testing modules from an online repository
Save-Module -Name Timezone -Repository PSGallery -Path C:\testmodule
Get-ChildItem -Path C:\testmodule\ -Recurse


## 8.4.6 Nested modules
see usesCount.psm1 - Listing 8.4

Import-Module .\usesCount.psm1
Get-Module

Get-Module usesCount | Format-List

Get-Module -All
Get-Command countup | Format-List -Force -Property Module*
Get-Command Get-Count | Format-List -Force -Property Module*

${function:CountUp}.File
${function:Get-Count}.File


## Import into the global environment with -Global
see usesCount2.psm1 - Listing 8.5

Import-Module .\usesCount2.psm1
Get-Module


## Import with -Scope parameter
see contents of scopetest folder in Chapter 8 folder


## 8.5 Binary modules
## 8.5.1 Creating a binary module
## see examplemodule.ps1 - Listing 8.6

Import-Module ./examplemodule.dll
Get-Module -Name examplemodule | Format-List
1,2,3 | Write-InputObject -Parameter1 'Number'


## 8.5.2 Nesting binary modules in script modules
## see wrapbinarymodule.psm1 - listing 8.7

Import-Module .\WrapBinaryModule.psm1 -Verbose

Get-Module WrapBinaryModule | Format-List Name, ExportedFunctions, ExportedCmdlets

wof 123

Import-Module .\WrapBinaryModule.psm1 -Force -ArgumentList $true -Verbose
Get-Module WrapBinaryModule | Format-List Name, ExportedFunctions, ExportedCmdlets