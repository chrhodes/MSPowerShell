## Code for chapter 4 PowerShell in Action third edition
##  This file contains the code from the chapter body. 
##  Any individual listings are supplied in separate files
##  Code has been unwrapped so may look slightly different 
##  to that presented in the book


## 4.2 Unary operators
$l = 1

#(expr) sends expression down pipeline

foreach ($s in "one","two","three")
{ 
   "$(($l++)): $s" 
}

# otherwise $l++ is treated as a "voidable statement"
# and is not sent down pipeline

foreach ($s in "one","two","three")
{ 
   "$($l++): $s" 
}

[void] $(Write-Output "discard me")


## 4.3 Grouping and subexpressions
(Get-ChildItem).count

## 4.3.1 Subexpressions $( ... )
$($c=$p=1; while ($c -lt 100) {$c; $c,$p=($c+$p),$c}).count

$a=0
$x=($a++)

$x=$($a++)
$x
$x -eq $null


## 4.3.2 Array subexpressions @( ... )
@(1)
@(@(1))
@(@(@(1)))

,1
,,1

$('bbb','aaa','ccc' | sort )[0]
$('bbb','aaa' | sort )[0]
$('aaa' | sort )[0]

@('bbb','aaa','ccc' | sort )[0]
@('bbb','aaa' | sort )[0]
@('aaa' | sort )[0]

( [object[]] ('aaa' | sort ))[0]


## 4.4.1 Comma operator
1,2,1+2
1,2,(1+2)

$a = (((1,2),(3,4)),((5,6),(7,8)))

$t1 = 1,2
$t2 = 3,4
$t3 = 5,6
$t4 = 7,8
$t1_1 = $t1,$t2
$t1_2 = $t3,$t4
$a = $t1_1, $t1_2

$a.Length
$a[0].Length
$a[1].Length
$a[1][0].Length
$a[1][0][1]


## 4.4.2 Range operator
1..3+4..6
1+3..4+6


## 4.4.3 Array indexing and slicing
(1,2,3)[0]
(1,2,3)[-1]
(1,2,3)[-2]


## Array slices
$a = 1,2,3,4,5,6,7
$indexes = 2,3,4,5
$a[$indexes]

$indexes = 2,3,4,5 | foreach {$_-1}
$a[$indexes]
$a[(2,3,4,5 | foreach {$_-1})]


## 4.4.4 Using the range operator with arrays
$a = 0..9
$a[0..3]
$a[-4..-1]
[string] $a[ ($a.Length-1) .. 0]

$a = $a[0,1] + 12 + $a[5 .. 9]
"$a"


## 4.4.5 Working with multidimensional arrays
see jaggedarrays.ps1

$2d = New-Object -TypeName 'object[,]' -ArgumentList 2,2
$2d.Rank

$2d[0,0] = "a"
$2d[1,0] = 'b'
$2d[0,1] = 'c'
$2d[1,1] = 'd'
$2d[1,1]

$2d[ (0,0) , (1,0) ]

$one = 0,0
$two = 1,0
$pair = $one,$two
$2d[ $pair ]


## 4.5 Property and method operators
'Hello world!'.Length
(1,2,3,4,5).Length


## 4.5.1 Dot operator
$prop = 'length'
'Hello world'.$prop

Get-ChildItem -Path c:\windows\*.dll | Get-Member -type property

Get-ChildItem -Path c:\windows\*.dll |
Get-Member -type property |
select Name

$obj = @(Get-ChildItem -Path $env:windir\system32\*.dll)[0]
$names = $obj | Get-Member -Type property l* | foreach {$_.name}
$names | foreach { "$_ = $($obj.$_)" }


## Fallback dot operator
$names = ( $obj | Get-Member -Type property l*).name
$names.foreach{ "$_ = $($obj.$_)" }


## Using methods
'Hello world!'.Substring(0,5)
[string]::join('+',(1,2,3))
[string]::join(' + ', (Get-Process p* | foreach{$_.handles}))


## 4.5.2 Static methods and the double-colon operator
$t = [string]
$t::join('+',(1,2,3))


## Using namespaces in PowerShell v5 and later

using assembly System.Windows.Forms
using namespace System.Windows.Forms
$form = [Form] @{
   Text = 'My First Form'
}
$button = [Button] @{
   Text = 'Push Me!'
   Dock = 'Fill'
}
$button.add_Click{
   $form.Close()
}
$form.Controls.Add($button)
$form.ShowDialog()


## 4.5.3 Indirect method invocation
'abc'.substring
'abc'.substring.Invoke(1)

$method = 'sin'
[math]::$method
[math]::$method.Invoke(3.14)


## 4.6 Format operator
'{2} {1} {0}' -f 1,2,3
'|{0,10}| 0x{1:x}|{2,-10}|' -f 10,20,30


## 4.7 Redirection and redirection operators
Get-Date > out.txt

Get-ChildItem out.txt,nosuchfile 2> err.txt
Get-Content err.txt

Get-Help Out-File -Full


## 4.8 Working with variables
Test-Path variable:NoSuchVariable
Get-ChildItem variable:/


## 4.8.1 Creating variables
Test-Path variable:myNewVariable
$myNewVariable = 'i exist'
Test-Path variable:myNewVariable


## Type-constrained variables
[int] $var = 2
$var
$var = '0123'
$var


## Attribute-constrained variables
[ValidateLength(0,5)] [string] $cv = ''
$cv = '12345'
$cv = '123456'


## 4.8.2 Variable name syntax
$_i_am_variable_number_2 = 2
${This is a variable name}

$global:var = 13
$global:var

$env:SystemRoot

${c:old.txt} -replace 'is (red|blue)','was $1' > new.txt
${c:new.txt} = ${c:old.txt} -replace 'is (red|blue)','was $1'
${c:old.txt} = ${c:old.txt} -replace 'is (red|blue)','was $1'

${c:f1.txt},${c:f2.txt} = ${c:f2.txt},${c:f1.txt}
${c:file.txt}.Length


## 4.8.3 Working with variable cmdlets
"Name", "Value"
"srcHost", "machine1"
"srcPath", "c:\data\source\mailbox.pst"
"destHost", "machine2"
"destPath", "d:\backup"

Get-Content variables.csv

Import-Csv .\variables.csv | 
foreach {Set-Variable -Name $_.Name -Value $_.Value}

Set-Variable -Name srcHost -Value machine3
$srcHost


## Getting and setting variable options
Get-Variable -ValueOnly srcHost
$srcHost = 'machine9'
$srcHost

Set-Variable -Option ReadOnly -Name srcHost -Value machine1
$srcHost = 'machine4'

Remove-Variable srcHost
Remove-Variable -Force srcHost

Set-Variable -Option Constant -Name srcHost -Value machine1


## Using PSVariable objects as references
$ref = Get-Variable -Name destHost
$ref.Name
$ref.Value
$ref.Value = 'machine12'
$destHost


## 4.8.4 Splatting a variable
function s {param ($x, $y, $z) "x=$x, y=$y, z=$z" }

$list = 1,2,3
s $list

s @list

$list += 5,6,7
s @list

function s {param ($x, $y, $z) "$x,$y,$z args=$args" }
s @list

s -y first -x second

$h = @{x='second'; y='first'}
s @h
s -z third @h 1 2 3