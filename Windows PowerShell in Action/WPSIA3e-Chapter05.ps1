## Code for chapter 5 PowerShell in Action third edition
##  This file contains the code from the chapter body. 
##  Any individual listings are supplied in separate files
##  Code has been unwrapped so may look slightly different 
##  to that presented in the book


## 5.1 Conditional statement
if ($x -gt 100){
  "It's greater than one hundred"
} elseif ($x -gt 50){
  "It's greater than 50"
} else {
  "It's not very big."
}

if (( Get-ChildItem *.txt | Select-String -List spam ).Length -eq 3) {
  'Spam! Spam! Spam!'
}

$x = 10
if ( $( if ($x -lt 5) { $false } else { $x } ) -gt 20) {$false} else {$true}


## 5.2.1 while loop
$val = 0
while($val -ne 3){
  $val++
  write-host "The number is $val"
}


## 5.2.2 do-while loop
$val = 0
do {
  $val++
  Write-Host "The number is $val"
} while ($val -ne 3)

$val = 0
do {
  $val++
  Write-Host "The number is $val"
} until ($val -ge 3)


## 5.2.3 for loop
for ($i=0; $i -lt 5; $i++) { $i }

for ($i=0; $($y = $i*2; $i -lt 5); $i++) { $y }

for ($($result=@(); $i=0); $i -lt 5; $i++) {$result += $i }
"$result"


## 5.3.4 foreach loop
$l = 0; foreach ($f in Get-ChildItem *.txt) { $l += $f.length }


## Evaluation order in the foreach loop
Get-ChildItem *.txt | ForEach-Object { $l += $_.length }


## Using the $foreach loop enumerator in the foreach statement
foreach ($i in 1..10){[void] $foreach.MoveNext(); $i + $foreach.Current }

[System.Collections.IEnumerator].Getmembers()|foreach{"$_"}

foreach ($i in "hi") {$i }


## The foreach loop and $null
foreach ($i in $null) { "executing" }

foreach ($i in $null, $null, $null) {"hi"}


## 5.3 Labels, break, and continue
$i=0; while ($true) { if ($i++ -ge 5) { break } $i }

foreach ($i in 1..10){
  if ($i % 2){
    continue
  }
  $i
}

:outer while (1){
  while(1){
    break outer;
  }
}

$target = 'foo'
:foo foreach ($i in 1..10) {
  if ($i -band 1) { continue $target } $i
}


## 5.4.1 Basic use of the switch statement
switch (1) { 1 { 'One' } 2 { 'Two' } }

switch (2) { 1 { 'One' } 2 { 'Two' } 2 {'another 2'} }

switch (2) {1 {'One'} 2 {'Two'; break} 2 {'another 2'}}

switch (3) { 1 { 'One' } 2 { 'Two' } default {'default'} }


## 5.4.2 Using wildcard patterns with the switch statement
switch ('abc') {'abc' {'one'} 'ABC' {'two'}}

switch -case ('abc') {'abc' {'one'} 'ABC' {'two'}}

switch -wildcard ('abc') {a* {'astar'} *c {'starc'}}

switch -wildcard ('abc') {a* {"a*: $_"} *c {"*c: $_"}}


## 5.4.3 Using regular expressions with the switch statement
switch -regex ('abc') {^a {"a*: $_"} 'c$' {"*c: $_"}}

switch -regex ('abc') {'(^a)(.*$)' {$matches}}

switch -regex ('abc') {'(^A)(.*$)' {$matches}}

switch (8) {
  {$_ -gt 3} {'greater than three'}
  {$_ -gt 7} {'greater than 7'}
}

switch (8) {
  {$_ -gt 3} {'greater than three'}
           8 {"Was $_"}
}

switch(1,2,3,4,5,6) {
  {$_ % 2} {"Odd $_"; continue}
         4 {'FOUR'}
   default {"Even $_"}
}

$dll=$txt=$log=0
switch -wildcard (Get-ChildItem c:\windows) {
  *.dll {$dll++}
  *.txt {$txt++}
  *.log {$log++}
}

$dll=$txt=$log=0
switch -wildcard (Get-ChildItem c:\windows) {
  *.dll {$dll += $_.length; continue}
  *.txt {$txt += $_.length; continue}
  *.log {$log += $_.length; continue}
}
"dlls: $dll text files: $txt log files: $log"


## 5.4.4 Processing files with the switch statement
Get-ChildItem $env:TEMP -File |
Select-Object -ExpandProperty Name |
Out-File $env:TEMP\files.txt

$lg=$tm=$cr=0
switch -regex -file $env:TEMP\files.txt {
  '\.log$' {$lg++}
  '\.tmp$' {$tm++}
  '\.cvr$' {$cr++}
}
"log:$lg tmp:$tm cvr:$cr"

$lg=$tm=$cr=0
switch -regex (${c:\temp\files.txt}) {
  '\.log$' {$lg++}
  '\.tmp$' {$tm++}
  '\.cvr$' {$cr++}
}
"log:$lg tmp:$tm cvr:$cr"


## 5.4.5 Using the $switch loop enumerator in the switch statement
$options= -split '-a -b Hello -c'

$a=$c=$d=$false
$b=$null

switch ($options){
  '-a' { $a=$true }
  '-b' { [void] $switch.MoveNext(); $b= $switch.Current }
  '-c' { $c=$true }
  '-d' { $d=$true }
}

"a=$a b=$b c=$c d=$d"


## 5.5.1 ForEach-Object cmdlet
ForEach-Object with scriptblock

foreach ($f in Get-ChildItem *.txt) { $f.length }
Get-ChildItem *.txt | foreach-object {$_.length}

1..5|%{$_*2}
gps svchost | %{$t=0}{$t+=$_.handles}{$t}

Get-Process -Name svchost |
foreach -Begin {$t=0} -Process {$t+=$_.handles} -End {$t}

$a = 1,(2,3)
$b = $a | foreach { $_ }
$b.length
$b[1]
$b = $a | foreach { , $_ }
$b.length
$b[1]

$b = $a | foreach { , $_ } | foreach { , $_ }
Get-Process | foreach {$_.modules} | sort -unique modulename


## How ForEach-Object processes its arguments
Get-ChildItem | foreach {$sum=0} {$sum++} {$sum}

Get-ChildItem | foreach {$sum=0} {$sum++} {$sum}
Get-ChildItem | foreach -begin {$sum=0} {$sum++} {$sum}
Get-ChildItem | foreach {$sum=0} {$sum++} -end {$sum}
Get-ChildItem | foreach -begin {$sum=0} {$sum++} -end {$sum}
Get-ChildItem | foreach -begin {$sum=0} -process {$sum++} -end {$sum}


## ForEach-Object with operation statement
Get-Process | ForEach-Object {$psitem.ProcessName}
Get-Process | ForEach-Object ProcessName
Get-Process | ForEach-Object -MemberName ProcessName

Get-Process | ForEach-Object ProcessName, Handles

'test', 'strings' | foreach {$_.ToUpper()}
'test', 'strings' | foreach ToUpper

'test', 'strings' | foreach Replace -ArgumentList 'st', 'AB'


## 5.5.2 Where-Object cmdlet
1..10 | where {-not ($_ -band 1)}
1..10|?{!($_-band 1)}
1..26|?{!($_-band 1)}|%{[string][char]([int][char]'A'+$_-1)*$_}


## Where-Object and Get-Content’s -ReadCount parameter
gc test.txt -ReadCount 1 | % { @($_).count } | select -first 1
gc test.txt -ReadCount 4 | % { @($_).count } | select -first 1

gc test.txt -read 5 | ? {$_ -like '*'} | % { $_.count }

(gc test.txt -read 10 | foreach {if ($_ -match '.') {$_}} |
Measure-Object).count

(gc test.txt -read 4 | foreach {$_} | where {$_ -like '*'} |
Measure-Object).count


## Where-Object simplified
Get-Process | where {$_.Handles -gt 1000}

Get-Process | where Handles -gt 1000
Get-Process | where -Property Handles -gt -Value 1000


## 5.6 Statements as values
$result = New-Object -TypeName System.Collections.ArrayList
for ($i=1; $i -le 10; $i++) { $result.Add($i) }
"$($result.ToArray())"

$result = for ($i=1; $i -le 10; $i++) {$i}
"$result"


## 5.7 A word about performance
$results = @()
for ($i=0; $i -lt $EventList.length ; $i++){
  $name = [string] $Events[$i].ProviderName
  $id = [long] $Events[$i].Id
  if ($name -ne "My-Provider-Name"){
    continue
  }
  if ($id -ne 3005) {
    continue
  }
  $results += $Events[$i]
}

$BranchCache3005Events = $events | 
where {$_.Id -eq 3005 -and $_.ProviderName -eq "My-Provider-Name"}

$BranchCache3005Events = @( foreach ($e in $events) {
if ($e.Id -eq 3005 -or $e.ProviderName -eq "Microsoft-Windows-BranchCacheSMB") {$e}} )

$s = -join $( foreach ($i in 1..40kb) { "a" } )

$s = ""; foreach ($i in 1..40kb) { $s += "a" }