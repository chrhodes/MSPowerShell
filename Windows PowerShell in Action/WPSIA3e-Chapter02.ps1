## Code for chapter 2 PowerShell in Action third edition
##  This file contains the code from the chapter body. 
##  Any individual listings are supplied in separate files
##  Code has been unwrapped so may look slightly different 
##  to that presented in the book

## 2.1.3 Type system and type adaptation

## Native members
Get-Date | Get-Member

## 2.1.4 Finding the available types

[System.AppDomain]::CurrentDomain.GetAssemblies()
[System.AppDomain]::CurrentDomain.GetAssemblies().GetTypes()

[System.AppDomain]::CurrentDomain.GetAssemblies().GetTypes() |
Select-String datetime

function Find-Type {
  param (
   [regex]$Pattern 
  )

[System.AppDomain]::CurrentDomain.GetAssemblies().GetTypes() |
Select-String $Pattern
}

[PowerShell].Assembly
[PowerShell].Assembly.Location

[PowerShell].Assembly.Location |
Get-ChildItem |
foreach LastWriteTime


## 2.2.1 String literals
"This is a string in double quotes"
'This is a string in single quotes'

"Embed double quote like this "" or this `" "
'Embed single quote like this '' '

$foo = "FOO"
"This is a string in double quotes: $foo"
'This is a string in single quotes: $foo'

"Expanding three statements in a string: $(1; 2; 3)"


## Here-string literals
$a = @"
One is "1"
Two is '2'
Three is $(2+1)
The date is "$(Get-Date)"
"@
$a

## Hexadecimal literals
0x10
0xDeadBeef

## 2.3.1 Creating and inspecting hashtables
$user = @{ FirstName = 'John'; LastName = 'Smith'; PhoneNumber = '555-1212' }
$user

$user = @{
FirstName = 'John'
LastName = 'Smith'
PhoneNumber = '555-1212'
}

$user.firstname
$user['firstname']
$user['firstname','lastname']

$user.keys
$user[$user.keys]


## 2.3.2 Ordered hashtables
$usero = [ordered]@{ FirstName = 'John'; LastName = 'Smith'; PhoneNumber = '555-1212' }
$usero

$oh = [ordered] @{ }
$oh[5] = 'five'
$oh[[object] 5] = 'five'
$oh[[object] 5]
$oh[0]

## 2.3.3 Modifying and manipulating hashtables
$user.date = Get-Date
$user['city'] = 'Seattle'
$user

$newHashTable = @{}
$newHashTable
$newHashTable.one = 1
$newHashTable.two = 2
$newHashTable


## 2.3.4 Hashtables as reference types
$foo = @{
a = 1
b = 2
c = 3
}
$foo.a

$bar = $foo
$bar.a

$foo.a = "Hi there"
$foo.a
$bar.a

$foo=@{a=1; b=2; c=3}
$bar = $foo.Clone()
$foo.a = "Hello"
$foo.a
$bar.a


## 2.4.1 Collecting pipeline output as an array
$a = 1,2,3
$a.GetType().FullName


## 2.4.2 Array indexing
$a[0] = 3.1415
$a[2] = 'Hi there'


## 2.4.3 Polymorphism in arrays
$a += 22,33
$a.length
$a[4]


## 2.4.4 Arrays as reference types
$a=1,2,3
"$a"

$b = $a
"$b"

$a[0] = 'Changed'
"$a"

"$b"

$b += 4
"$b"


## 2.4.5 Singleton arrays and empty arrays
(, 1).length
@().length

@(1)
@(1).length

(1,2,3).Length
( , (1,2,3) ).Length
( @( 1,2,3 ) ).Length


2.5 Type literals
$i = [int] '123'
$i = [System.Int32] '123'
$i = [int[]] '123'


## 2.5.1 Type name aliases
$tna = [psobject].Assembly.GetType('System.Management.Automation.TypeAccelerators')::Get
$tna.GetEnumerator() | Sort-Object Key


## 2.5.2 Generic type literals
[system.collections.generic.list[int]] | Format-Table -Autosize

$l = New-Object System.Collections.Generic.List[int]
$l.add(1)
$l.add(2)

[system.collections.generic.dictionary[string,int]] |
Format-Table -Autosize


## 2.5.3 Accessing static members with type literals
[string] | Get-Member -Static
$s = 'one','two','three'
[string]::Join(' + ', $s)


## 2.6.1 How type conversion works
[int] '0x25'
[int] [char]'a'
[int[]] [char[]] 'Hello world'

"0x{0:x}" -f [int] [char] 'a'
[string][char][int] ("0x{0:x}" -f [int] [char] 'a')


## 2.6.3 Special type conversions in parameter binding
## Scriptblock parameters
Get-ChildItem -Path *.xml |
Rename-Item -Path {$_.Name} -NewName {$_.Name -replace '\.xml$', '.txt'} -Whatif