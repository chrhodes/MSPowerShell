############################################################
#
# Windows PowerShell in Action Chapter 11
# 
# Metaprogramming with scriptblocks and dynamic code
#
# 11.1 Scriptblock basics
#
# 11.2 Building and manipulating objects
#
# 11.3 Using the Select-Object cmdlet
#
# 11.4 Dynamic modules
#
# 11.5 Steppable pipelines
#
# 11.6 A closer look at the type-system plumbing
#
# 11.7 Extending the PowerShell language
#
# 11.8 Building script code at runtime
#
# 11.9 Compiling code with Add-Type
#
############################################################
#
#
# ScriptBlocks as functions without names
# Enclosed in {}
# Contain statements
# Can have parameters
# Can have Begin and End statements
# 
# {
#    param ( <parameter list> )
#    begin   { <statements to process before any items processed> }
#    process { <statements to process for each item in pipeline>  }
#    end     { <statements to process after all items processed>  }
# }

1..5
1..5 | & { process{ $_ * 2 } }
1..5 | ForEach-Object { process{ $_ * 2 } }  # foreach as shortcut for more complex script block

# Get list of functions
dir function:

function foo {2+2}
foo
foo | Get-member
foo | get-member -static
dir foo
dir function:foo
dir function:foo | Get-Member

dir function:foo | format-list

# Functions contain a ScriptBlock property
dir function:foo | format-list -Property *

# Different ways to get script block content
(dir function:foo).ScriptBlock
$function:foo

# See the type is System.Management.Automation.ScriptBlock
$function:foo.GetType().Fullname

# Can change the scriptblock!
$function:foo = {3+3}
foo

# Building and manipulating objects (data + behaviors)
# Type as template, object as instance of type
# Object's interface as set of public members
# Public members fields, properties, methods

# Look at members (Instance)
12 | get-member
"Hello" | Get-Member

# Look at members (Static)
12 | Get-Member -Static
"Hello" | Get-Member -Static

# Need to learn why this doesn't work??

Get-Member | Get-Member
(Get-Member).GetType()
(Get-Member) | Get-Member
Get-Member

# Defining synthetic members (not natively part of object's definition)
# See "NoteProperty" attached to these types

dir $profile | Get-Member ps*             # System.IO.FileInfo
dir hklm:\software | Get-Member ps*       # Microsoft.Win32.RegistryKey

# Using Add-Member to extend objects
# Types that can be added with Add-Member
# AliasProperty
# CodeProperty
# Property
# NoteProperty
# ScriptProperty
# Properties
# Method
# CodeMethod
# ScriptMethod
# ParameterizedProperty
# PSVariableProperty

# Adding AliasProperty members

$s = "Hello World"
$s
$s.Length

$s | Get-Member length

# Add alias "size" to $s

$s = Add-Member -PassThru -InputObject $s AliasProperty Size Length
$s.Length
$s.Size

$s | Get-Member size

# Adding things wraps the base objec in a PSObject

$s -is [PSObject]
"Abc" -is [PSObject]
$s -is [string]

[PSObject] | get-member

# Adding NoteProperty members (like a sticky note)
# Since $s is already wrapped in PSObject don't need to use PassThru

Add-Member -InputObject $s NoteProperty Description "S is a String"
$s.Description
($s.Description).GetType()
($s.Description).GetType().Fullname

# Only affects $s not all strings

"Hello".Description

# Can change type

$s.Description = Get-Date
$s.Description
($s.Description).GetType()
($s.Description).GetType().Fullname

# Adding ScriptMethod members
# Create a new method on string that reverses characters
# First see how the static method "Reverse" on array can be used.

$s = "Hello World"
$a = [char[]] $s
$s
$a
"$a"
[array]::Reverse($a)
"$a"

# Use unary operator, "-join" to join elements of array
$ns = -join $a
$ns

# Now create a script
# NB the "$this" variable.  Only on Scriptblocks used as methods or properties.
#    Holds the reference to object script block called from.

$sb = {
  $a = [char[]] $this
  [array]::Reverse($a)
  -join $a
}

# Now add to our string
# NB.  Need to reassign to $s as we changed $s above when assigned Get-Date

$s = Add-Member -PassThru -InputObject $s ScriptMethod Reverse $sb

$s | get-member

$s.Reverse()

# Adding ScriptProperty members
# Add two methods (Getter and Setter)
# Referenced object in $this
# Value assigned in $args[0]

Add-Member -InputObject $s ScriptProperty Desc `
  {$this.Description} `
  {
    $t = $args[0]
    if ($t -isnot [string]) {
      throw "this property only takes strings"
    }
    $this.Description = $t
  }

$s | Get-Member

$s.Description = "Old Description"
$s.Desc

$s.Desc = "New Description"
$s.Desc
$s.Description

$s.Description = Get-Date
$s.Description
$s.Desc = Get-Date

# Adding note properties with New-Object and a hash table
# This is a short hand instead of using Add-Member to add NoteProperty

$obj = New-Object PSObject -Property @{a=1; b=2; c=3}
$obj | Format-Table -AutoSize
$obj | Get-Member

# Using Select-Object cmdlet

# Select some elements

1..10 | Select-Object -First 3

# Select only some properties.  Creates synthetic object

dir | Select-Object name, length
dir | Select-Object name, length | Get-Member

# Add new property on the fly.  Create HashTable and Use Expression Syntax
# @{Name="Minute" ; Expression={$_.LastWriteTime.Minute} }

dir | Select-Object name, length,
    @{Name="Minute" ; Expression={$_.LastWriteTime.Minute} }

dir | Select-Object name, length,
    @{Name="Minute" ; Expression={$_.LastWriteTime.Minute} } | Get-Member

# Dynamic Modules
# In memory modules created at runtime
# Two types: dynamic script and 

# Use New-Module to create dynamic module

$dm = New-Module {
    $c=0
    function Get-NextCount
    {
        $script:c++; $script:c
    }
}

# If no call to Export-ModuleMember, all functions are exported
# but nothing else.

Get-NextCount
Get-NextCount
$c

# Get-Module does not see new module

Get-Module

$dm | get-member

# NB. PS created Name and Path

$dm | Format-List

# So can be registered by importing

$dm | Import-Module

Get-Module

# Can give better name when creating.
# First cleanup

Get-Module -Name __DynamicModule_192824f0-e7cd-463d-b788-ea3d62dab638 | Remove-Module
Get-Module

# And create with a better name and import directly into Module-Import

New-Module -Name Dynamic1 {
    $c=0
    function Get-NextCount
    {
        $script:c++; $script:c
    }
} | Import-Module

Get-Module

# Use Dynamic modules when you need functions with persistent resources
# and don't want to expose those resources at global level
# Also to implement the idea of "Closures"
# Closure (Wikipedia) "a function that is evaluated in an environment
#                      containing one or more bound variables."
# function       = scriptblock
# environment    = dynamic module
# bound variable = variable that exists and has value
#
# An Object  is   data     with functions (methods) attached to the data
# A  Closure is a function with data                attached to the function

function New-Counter ($increment=1)
{
    $count=0;
    {
        $script:count += $increment
        $count
    }.GetNewClosure()
}

# Create a counter

$c1 = New-Counter
$c1.GetType().FullName

# Since it is a scriptblock you can invoke it

& $c1
& $c1

# Now create a new counter but change the increment

$c2 = New-Counter 2
& $c2
& $c2

# Note first counter still works as expected

& $c1

# When new closure is created, a new dynamic module is created
# each containing all variables in callers scope, e.g. $increment and $count

# Can create closures with param and script blocks.  Don't have to declare function

$c = & {param ($x) {$x + $x}.GetNewClosure()} 3.145
& $c

# Now watch this. Change the the value of x

& $c.Module Set-Variable x "Foo"
& $c

# Now create a new scriptblock closed over the same module as the first one

$c2 = $c.Module.NewBoundScriptBlock({"x is $x"})

& $c2

# Now update the shared variable

& $c2.Module Set-Variable x 123
& $c2

# And verify also changed for original closed scriptblock
& $c

# Finally create a named function from the scriptblock using the function provider

$function:myFunc = $c

# And verify that calling the function by name works.

myFunc

# Set the closed variable again, but use $c2 to access the module

& $c2.Module Set-Variable x 3

# And verify it changed the named function

myFunc

# This is how modules work.
# When a module is loaded, the exported functions are closures bound
# to the module object that was created.
# These closures are assigned to the names for the function to import.

# Creating custom objects from dynamic modules
# Modules have private data and public members just like objects

function New-Point
{
    New-Module -ArgumentList $args -AsCustomObject {
        param (
            [int] $x = 0,
            [int] $y = 0
        )
        function ToString()
        {
            "($x, $y)"
        }
        Export-ModuleMember -Function ToString -Variable x,y
    }
}

# Look at what is visible (x,y) as NoteProperty.  This is because of the -Variable export

new-Point | Get-Member
new-Point | format-list

# Define two points

$p1 = New-Point 1 1
$p2 = New-Point 2 3

# Use string expansion to call ToString()

"p1 is $p1"
"p2 is $p2"

# NB. that x and y are type safe

$p1.x = 9
$p1.y = "X"

##############################
# 11.5 Steppable PipeLines
##############################

# Used to allow one command to wrap, or proxy, other commands.

# 11.5.1 How steppable pipelines work

# 11.5.2 Creating a proxy command with stepable pipelines

# 11.6 A closer look at the type-system plumbing

# 11.6.1 Adding a property

# 11.6.2 Shadowing an existing property

# 11.7 Extending the PowerShell language

# 11.7.1 Little languages

# 11.7.2 Adding a CustomClass keyword to PowerShell

# 11.7.3 Type extension

# 11.8 Building script code at runtime

# 11.8.1 The Invoke-Expression cmdlet

# 11.8.2 The ExecutionContext variable

# 11.8.3 The ExpandString() method

# 11.8.4 The InvokeScript() method

# 11.8.5 Mechanisms for creating scriptblocks

# 11.8.6 Creating functions using the function drive

# 11.9 Compiling code with Add-Type

# 11.9.1 Defining a new .NET class: C#

# 11.9.2 Defining a new enum at runtime 

# 11.9.3 Dynamic binary modules

# 11.10 Summary