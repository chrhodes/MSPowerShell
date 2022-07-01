############################################################
#
# Windows PowerShell in Action Chapter 5
#
# Advanced Operators and Variables
#
# 5.1 Operators for working with types
#
# 5.2 The Unary operators
#
# 5.3 Grouping and subexpressions
#
# 5.4 Array operators
#
# 5.5 Property and method operators
# 
# 5.6 The format operator
#
# 5.7 Redirection and the redirection operators
#
# 5.8 Working with variables
#
############################################################

# 5.1 Operators for working with types


# 5.2 The Unary operators


# 5.3 Grouping and subexpressions

# 5.3.1 Subexpressions $(...)

# 5.3.2 Array subexpressions (@(...)

# 5.4 Array operators

# 5.4.1 The comma operator

# 5.4.2 The range operator

# 5.4.3 Array indexing and slicing

# 5.4.4 Using the range operator with arrays

# 5.4.5 Working with multidimensional arrays

# 5.5 Property and Method Operators

# <typeValue>::<memberNameExpr>
# <typeValue>::<memberNameExpr>(<arguments>)
# <value>.<memberNameExpr>
# <value>.<memberNameExpr>(<arguments>)

# "." as property dereference operator

# Length of string

$x = "Hello"
$x.Length
"Hello World".Length

# Length of array

(1,2).Length
("foo", 23, 1.3).Length
(1,2).Count

# Look at types.ps1xml to see magic mapping of Count to Length
#    <Type>
#        <Name>System.Array</Name>
#        <Members>
#            <AliasProperty>
#                <Name>Count</Name>
#                <ReferencedMemberName>Length</ReferencedMemberName>
#            </AliasProperty>
#        </Members>
#    </Type>

# 5.5.1 The dot operator
#
# . is a binary operator with expressions on both sides
#
# (<expr>).(<expr>)
#
# ("*" * 5).("len" + "gth")
# ("*" * 5).length
# "*****".length

("*" * 5).("len" + "gth")

$prop = "length"

"Foo Bar".$prop

# To get the list of properties on an object
# | Get-Member -type property | foreach {$_.name}

"Hello" | Get-Member
"Hello" | Get-Member -type property | foreach {$_.name}
"Hello" | Get-Member -type Method   | foreach {$_.name}
"Hello" | Get-Member -static -type Method   | foreach {$_.name}

$obj = @(dir c:\windows\*.dll)[0]
$obj
$names = $obj | Get-Member -type property | foreach {$_.name}
$names | foreach { "$_ = $($obj.$_)" }

# Invoking methods

"Hello World".Substring(1,4)

# Have to wrap array arguments in parentheses

[string]::join('+',(1,2,3))

# and the output of commands

get-process s* | foreach{$_.handles}
[string]::join(" + ", (get-process s* | foreach{$_.handles}))

# Use "::" to invoke static methods

# Indirectly invoking methods
# have to use .Invoke.  Can't do something like $x.$y(2)

"abc".substring
"abc".Substring | Get-Member

"Hello World".Substring.Invoke(1,4)

$method = "tan"
[math]::$method

[math]::$method.invoke(1.0)

# 5.6 The Format Operator

# <formatSpecification> -f <argumentList>

# 5.7 Redirection and the redirection operators

# 5.8 Working with variables

# 5.8.1 Creating variables

# 5.8.2 Variable name syntax

# 5.8.3 Working with the variable cmdlets

# 5.8.4 Splatting a variable

# 5.9 Summary

