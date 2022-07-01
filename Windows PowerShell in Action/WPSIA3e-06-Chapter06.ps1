## Code for chapter 6 PowerShell in Action third edition
##  This file contains the code from the chapter body. 
##  Any individual listings are supplied in separate files
##  Code has been unwrapped so may look slightly different 
##  to that presented in the book


## 6.1 Fundamentals of PowerShell functions
function hello { 'Hello world' }
hello

## 6.1.1 Passing arguments using $args
function hello { "Hello there $args, how are you?" }
hello Bob
hello Bob Alice Ted Carol


function hello {
  $ofs=","
  "Hello there $args and how are you?"
}
hello Bob Carol Ted Alice
hello Bob,Carol,Ted,Alice

function count-args {
  "`$args.count=" + $args.count
  "`$args[0].count=" + $args[0].count
}
count-args 1 2 3
Count-Args 1,2,3
count-args 1,2,3 4,5,6,7


## 6.1.2 Example functions: ql and qs
function ql { $args }
function qs { "$args" }

$col = "black","brown","red","orange","yellow","green","blue","violet","gray","white"

$col = ql black brown red orange yellow green blue violet gray white

$string = qs This is a string
$string


## 6.2 Declaring formal parameters for a function
function subtract ($from, $count) { $from - $count }
subtract 5 3
subtract -from 5 -count 2
subtract -from 4 -count 7
subtract -from 5 6
subtract -count 5 6


## 6.2.1 Mixing named and positional parameters
function subtract ($from, $count) { $from - $count }


## 6.2.2 Adding type constraints to parameters
function nadd ([int] $x, [int] $y) {$x + $y}
nadd 1 2
nadd '1' '2'
nadd @{a=1;b=2} '2'

function add ($x, $y) {$x + $y}
add @{a=1;b=2} '2'


## 6.2.3 Handling variable numbers of arguments
function a ($x, $y) {
  "x is $x"
  "y is $y"
  "args is $args"
}
a 1
a 1 2
a 1 2 3


## 6.2.4 Initializing function parameters with default values
function add ($x=1, $y=2) { $x + $y }
add
add 5
add 5 5

function dow ([datetime] $d = $(Get-Date)) {
  $d.dayofweek
}
dow
dow 'oct 10, 2017'


## 6.2.5 Using switch parameters to define command switches
function get-soup (
  [switch] $please,
  [string] $soup= 'chicken noodle'
)
{
  if ($please) {
    "Here's your $soup soup"
  }
  else
  {
    'No soup for you!'
  }
}

get-soup
get-soup -please
get-soup -please tomato


## Specifying arguments to switch parameters
Get-ChildItem -Recurse: $true

function foo ([switch] $s) { "s is $s" }
foo -s
foo

function bar ([switch] $x) { "x is $x"; foo -s: $x }
bar
bar -x


## 6.2.6 Switch parameters vs. Boolean parameters
function tb ([bool] $x) { [bool] $x }
tb
tb -x
tb -x $true
tb -x $false


## A digression: the Get/Update/Set pattern
see listing 6.1

Get-Character

Get-Character |
Update-Character -name snoopy -human $false |
Format-Table -AutoSize

Get-Character |
Update-Character -name snoopy -human $false |
Set-Character

Get-Character

Get-Character L*

Get-Character Linus |
Update-Character -age 7 |
Set-Character

Get-Character | Format-Table -AutoSize


## 6.3 Returning values from functions
2+2; 9/3; [math]::sqrt(27)

function numbers { 2+2; 9/3; [math]::sqrt(27) }
numbers
$result = numbers
$result.length
$result[0]
$result[1]
$result[2]

function numbers{
  $i=1
  while ($i -le 10){
    $i
    $i++
  }
}
$result = numbers
$result.GetType().FullName
$result.length


## 6.3.1 Debugging problems in function output
function my-func ($x) {
  "Getting the date"
  $x = get-date
  "Date was $x, now getting the day"
  $day = $x.day
  "Returning the day"
  $day
}

my-func
$x = my-func

$al = New-Object -TypeName System.Collections.ArrayList
$al.count
$al.add(1)
$al.add(2)

function addArgsToArrayList {
  $al = New-Object -TypeName System.Collections.ArrayList
  $args | foreach { $al.add($_) }
}
addArgsToArrayList a b c d

function addArgsToArrayList {
  $al = New-Object -TypeName System.Collections.ArrayList
  $args | foreach { [void] $al.add($_) }
}
addArgsToArrayList a b c d


## 6.4 Using simple functions in a pipeline
function sum {
  $total=0;
  foreach ($n in $input) { $total += $n }
  $total
}

function sum2 {
  $total=0
  while ($input.MoveNext()){
    $total += $input.Current
  }
  $total
}

function sum3 ($p){
  $total=0
  while ($input.MoveNext()){
    $total += $input.Current.$p
  }
  $total
}

Get-ChildItem | sum3 length


## 6.4.1 Functions with begin, process, and end blocks
function my-cmdlet ($x) {
  begin {$c=0; "In Begin, c is $c, x is $x"}
  process {$c++; "In Process, c is $c, x is $x, `$_ is $_"}
  end {"In End, c is $c, x is $x"}
}

1,2,3 | my-cmdlet 22
my-cmdlet 33


## 6.5 Managing function definitions in a session
Get-ChildItem –Path function:\mkdir
(Get-ChildItem function:\).count

function clippy { "I see you're writing a function." }

Get-ChildItem function:\clippy

Get-ChildItem function:\clippy |
Format-Table CommandType, Name, Definition -AutoSize -Wrap

Remove-Item function:/clippy

(Get-ChildItem function:/).count
Get-ChildItem function:clippy


## 6.6 Variable scoping in functions
## 6.6.1 Declaring variables
function one { "x is $x" }
function two { $x = 22; one }

$x=7
one
two

$x
one


## 6.6.2 Using variable scope modifiers
$global:var
function one { "x is $global:x" }
function two { $x = 22; one }

$x=7
one
two