## Code for chapter 3 PowerShell in Action third edition
##  This file contains the code from the chapter body. 
##  Any individual listings are supplied in separate files
##  Code has been unwrapped so may look slightly different 
##  to that presented in the book


## 3.1.1 Addition operator
$a = [int[]] (1,2,3,4)
$a[0] = 10
$a[0] = '0xabc'

$a[0] = 'hello'

$a = $a + 'hello'
$a[0] = 'hello'
$a.GetType().FullName


## 3.1.2 Multiplication operator
'abc' * 3

'abc' * 0
('abc' * 0).GetType().FullName
('abc' * 0).Length

$a=1,2,3
$a.Length
$a = $a * 2
$a.Length


## 3.1.3 Subtraction, division, and the modulus operators
'123' / '4'


## 3.2 Assignment operators
$a,$b,$c = 1,2,3,4


## 3.2.1 Multiple assignments
$temp = $a
$a = $b
$b = $temp

$a,$b = $b,$a


## 3.2.2 Multiple assignments with type qualifiers

quiet 0 25
normal 26 50
loud 51 75
noisy 76 100

$data = Get-Content -Path data.txt | 
foreach {
  $e=@{}
  $e.level, [int] $e.lower, [int] $e.upper = -split $_
  $e
}

$data.Length
$data[0]


## 3.2.3 Assignment operations as value expressions
$a = $b = $c = 3
$a = ( $b = ( $c = 3 ) )
$a = ( $b = ( $c = 3 ) + 1 ) + 1


## 3.3.1 Scalar comparisons
[int]'123' -lt 123.4
[int] "123" -lt "123.4"
[double] "123" -lt "123.4"


## 3.3.2 Comparisons and case sensitivity
'abc' -eq 'ABC'
'abc' -ieq 'ABC'
'abc' -ceq 'ABC'

[DateTime]'1/1/2017' -gt (Get-Process powershell*)[0].StartTime
[DateTime]'1/1/2018' -gt (Get-Process powershell*)[0].StartTime

Get-Process | where {$_.starttime -ge [DateTime]::today}


## 3.3.3 Using comparison operators with collections
1,'2',3,2,'1' -eq '2'
1,'02',3,02,'1' -eq '2'
1,'02',3,02,'1' -eq 2


## Containment operators
1,'02',3,02,'1' -contains '02'
1,'02',3,02,'1' -notcontains '02'

$false,$true -eq $false
$false,$true -contains $false

@($false,$true -eq $false).count

1,2,3 -contains 2
2 -in 1,2,3

$names = 'powershell', 'powershell_ise'
Get-Process | where Name -in $names

Get-Process | where {$names -contains $_.Name}


## 3.4.1 Wildcard patterns and the -like operator
Get-ChildItem -Path *.txt
Get-ChildItem -Path [fm]*.txt


## 3.4.3 The -match operator
'abcdef' -match '(a)(((b)(c))de)f'


## Matching using named captures
'abcdef' -match '(?<o1>a)(?<o2>((?<e3>b)(?<e4>c))de)f'
$matches


## Parsing command output using regular expressions
(net config workstation)[1]

$p='^Full Computer.* (?<computer>[^.]+)\.(?<domain>[^.]+)'
(net config workstation)[1] -match $p

$matches.computer
$matches.domain


## 3.4.4 The -replace operator
'1,2,3,4' -replace '\s*,\s*','+'
${c:old.txt} -replace 'is (red|blue)','was $1' > new.txt

'The car is red' -replace 'is (red|blue)','was $1'
'My bike is yellow' -replace 'is (red|blue)','was $1'

$a = 'really'
'The car is red' -replace 'is (red|blue)',"was $a `$1"

'The quick brown fox' -replace 'quick'


## 3.4.5 The -join operator
$in = 1,2,3
$out = -join $in
$out
$out.GetType().FullName

$ca = [char[]] 'abcd'
[array]::Reverse($ca)
$ra = -join $ca
$ra

-join 1,2,3
(-join 1),2,3
-join (1,2,3)

$numbers = 1,2,3
$exp = $numbers -join '+'
$exp

$fact = Invoke-Expression (1..10 -join '*')
$fact

@'
line1
line2
line3
'@ > out.txt
$text = Get-Content -Path out.txt

$single = $text -join "`r`n"
$single2 = Get-Content -Path out.txt -Raw


## 3.4.6 The -split operator
'a:b:c:d:e' -split ':'
'a:b:c:d:e' -split ':',3

'a*b*c' -split '*'


U## sing scriptblocks with the -split operator
$colors = "Black,Brown,Red,Orange,Yellow," +
"Green,Blue,Violet,Gray,White"

$count=@(0)
$colors -split {$_ -eq ',' -and ++$count[0] % 2 -eq 0 }
