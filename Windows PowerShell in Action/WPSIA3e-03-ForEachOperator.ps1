##  Chapter 3 PowerShell in Action third edition
##  Section 3.6.2

(1..5).ForEach({$_ * 2}) 

$data = 1,2,3,4,5

## script block 
($data).ForEach({$_ * 2}) 

$data.ForEach({$_ * 2})

## type conversion
$data | Get-Member
$data.ForEach([double]) | Get-Member

## property names
(Get-Process).foreach('Name')

## method invocation
(Get-Process -Name notepad).foreach('Name')
(Get-Process -Name notepad).foreach('Kill')