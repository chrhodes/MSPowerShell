## Code for chapter 1 PowerShell in Action third edition
##  This file contains the code from the chapter body. 
##  Any individual listings are supplied in separate files
##  Code has been unwrapped so may look slightly different 
##  to that presented in the book

## Introduction

'Hello world.'

Get-ChildItem -Path $env:windir\*.log |
Select-String -List error |
Format-Table Path,LineNumber –AutoSize

([xml] [System.Net.WebClient]::new().DownloadString('http://blogs.msdn.com/powershell/rss.aspx')).RSS.Channel.Item |
Format-Table title,link


using assembly System.Windows.Forms
using namespace System.Windows.Forms
$form = [Form] @{
   Text = 'My First Form'
}
$button = [Button] @{
   Text = 'Push Me!'
   Dock = 'Fill'
}
$button.add_Click{$form.Close()}

$form.Controls.Add($button)
$form.ShowDialog()


## 1.2 PowerShell example code
Get-ChildItem -Path C:\somefile.txt
Get-ChildItem -Path C:\somefile.txt > c:\foo.txt
Get-Content -Path C:\foo.txt


## 1.2.1 Navigation and basic operations
Get-Help dir


## 1.2.2 Basic expressions and variables
(2+2)*3/7 > c:\foo.txt
Get-Content c:\foo.txt

$n = (2+2)*3
$n
$n / 7

$files = Get-ChildItem
$files[1]


## 1.2.3 Processing data

Sorting objects
cd c:\files
Get-ChildItem

Get-ChildItem | sort -Descending
Get-ChildItem | sort -Property length

Selecting properties from an object
$a = Get-ChildItem | 
sort -Property length -Descending |
Select-Object -First 1
$a

$a = Get-ChildItem | 
sort -Property length -Descending |
Select-Object -First 1 -Property Directory
$a

Processing with the ForEach-Object cmdlet
$total = 0
Get-ChildItem | ForEach-Object {$total += $_.length }
$total

Processing other kinds of data
Get-ChildItem | sort -Descending length | select -First 3

Get-Process | sort -Descending ws | select -First 3


## 1.2.4 Flow-control statements
$i=0
while ($i++ -lt 10) { if ($i % 2) {"$i is odd"}}

foreach ($i in 1..10) { if ($i % 2) {"$i is odd"}}

1..10 | foreach { if ($_ % 2) {"$_ is odd"}}


## 1.2.5 Scripts and functions
param($name = 'bub')
"Hello $name, how are you?"

.\hello
.\hello Bruce

function hello {
param($name = "bub")
"Hello $name, how are you"
}

hello
hello Bruce


## 1.2.6 Remote administration
Get-HotFix -Id KB3213986

Invoke-Command -ScriptBlock {Get-HotFix -Id KB3213986} -ComputerName W16DSC01

$computers = 'W16DSC01', 'W16DSC02'
Invoke-Command -ScriptBlock {Get-HotFix -Id KB3213986} -ComputerName $computers |
Format-Table HotFixId, InstalledOn, PSComputerName -AutoSize

Enter-PSSession -ComputerName W16DSC01
Get-HotFix -Id KB3213986 | Format-Table -AutoSize
Exit-PSSession


## 1.3 Core concepts
Write-Output -InputObject Hello
Write-Output Hello

Write-Output -InputObject "-InputObject"
Write-Output "-InputObject"
Write-Output -- -InputObject

Get-ChildItem -Recurse -Filter c*d.exe C:\Windows


## 1.3.3 Command categories

## Native commands (applications)
.\foo.txt
notepad foo.txt
notepad foo.txt | sort-object

powershell { Get-Process *ss } | Format-Table name, handles

## 1.3.4 Aliases and elastic syntax
Get-Command dir
Get-Command Get-ChildItem
Get-Command fl

gcm|?{$_.parametersets.Count -gt 3}|fl name

Get-Command |
Where-Object {$_.parametersets.count -gt 3} |
Format-List name


## 1.4.2 Quoting
Write-Output '-InputObject'
Set-Location 'c:\program files'
Get-Location

Set-Location c:\program` files
Get-Location

$v = 'files'
Set-Location "c:\program $v"
Get-Location

Write-Output "`$v is $v"
Write-Output "`$v is '$v'"
"The value of `$v is:`n$v"


## 1.4.5 Comment syntax in PowerShell
echo hi#there
echo hi #there
(echo hi)#there
echo hi;#there
echo hi+#there

"hi"+#there

function hi#there { "Hi there" }
hi#there

## Multiline Comments
<# a comment #> "Some code"


## 1.5.1 Pipelines and streaming behavior
Get-ChildItem -Path C:\Windows\ -recurse -filter *.dll |
where Name -match "system.*dll"


##  Parameters and parameter binding
Write-Output 123
123 | Write-Output

Trace-Command -Name ParameterBinding -Option All -Expression { 123 | Write-Output } -PSHost


## 1.6 Formatting and output
Get-ChildItem $PSHOME/*format* | Format-Table name


## 1.6.1 Formatting cmdlets
Get-Command Format-* | Format-Table name

Get-Item c:\ | Format-Table
Get-Item c:\ | Format-List

Get-Process –Name s* | Format-Wide -Column 8 id
Get-Item c:\ | Format-Custom -Depth 1


## 1.6.2 Outputter cmdlets

dir | Out-Default
dir | Format-Table
dir | Format-Table | Out-Default

Get-Command Out-* | Format-Wide -Column 3

Out-File -encoding blah