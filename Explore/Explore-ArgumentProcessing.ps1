<# 

.SYNOPSIS 
A brief description of the function or script. 
This keyword can be used only once in each topic.

.DESCRIPTION
A detailed description of the function or script.
This keyword can be used only once in each topic
		
.PARAMETER firstNamedArgument
The description of a parameter. You can include a Parameter keyword for
each parameter in the function or script syntax.

The Parameter keywords can appear in any order in the comment block, but
the function or script syntax determines the order in which the parameters
(and their descriptions) appear in Help topic. To change the order,
change the syntax.
 
You can also specify a parameter description by placing a comment in the
function or script syntax immediately before the parameter variable name.
If you use both a syntax comment and a Parameter keyword, the description
associated with the Parameter keyword is used, and the syntax comment is
ignored.

.PARAMETER secondNamedArgument
blah blah about secondNamedArgument

.EXAMPLE
A sample command that uses the function or script, optionally followed
by sample output and a description. Repeat this keyword for each example.
.EXAMPLE
Example2

.INPUTS
blah blah about Inputs

.OUTPUTS
blah blah about outputs

.NOTES
Additional information about the function or script.

.LINK
The name of a related topic. Repeat this keyword for each related topic.

This content appears in the Related Links section of the Help topic.

The Link keyword content can also include a Uniform Resource Identifier
(URI) to an online version of the same Help topic. The online version 
opens when you use the Online parameter of Get-Help. The URI must begin
with "http" or "https".

.COMPONENT
The technology or feature that the function or script uses, or to which
it is related. This content appears when the Get-Help command includes
the Component parameter of Get-Help.

.ROLE
The user role for the Help topic. This content appears when the Get-Help
command includes the Role parameter of Get-Help.

.FUNCTIONALITY
The intended use of the function. This content appears when the Get-Help
command includes the Functionality parameter of Get-Help.


<ScriptName - Consider Verb-Noun>.ps1

SCC:
	This script is under source code control.  Modifications should be 
	checked into the VSS repository located at 
		\\life.pacificlife.net\life\it\vss\TechOffice
	under a project 
		$PowerShell/Scripts

Last Update:

v1.0.0 <Author>, <Date>, <Company>

Be sure to leave two blank lines after end of block comment.
#>

param(
$firstNamedArgument, 
$secondNamedArgument = 0)
# Display the arguments by position
"First positional script argument is: " + $args[0]
"Second positional script argument is: " + $args[1]
# Display the arguments by name
"First named argument is: $firstNamedArgument"
"Second named argument is: $secondNamedArgument"

# Declare some functions taking arguments


function GetArgumentsFunction
{
	# A param statement can be used here, as well

	param($argumentOne, $argumentTwo = 0)

	"  --Inside GetArgumentsFunction after param statement"
	# Display the arguments by position
	"    First positional function argument is: " + $args[0]
	"    Second positional function argument is: " + $args[1]
	"    First global positional function argument is: " + $global:args[0]
	"    Second global positional function argument is: " + $global:args[1]	
	"    First script positional function argument is: " + $script:args[0]
	"    Second script positional function argument is: " + $script:args[1]	
	"    First local positional function argument is: " + $local:args[0]
	"    Second local positional function argument is: " + $local:args[1]	
	# Display the arguments by name
	"    First named function argument is: " + $argumentOne
	"    Second named function argument is: " + $argumentTwo
}

function GetArgumentsFunction2
{
	# note the the second argument has been strongly typed to expect an int
	param($argumentOne, [int] $argumentTwo = 0)
	"  --Inside GetArgumentsFunction2"

	"    First positional function argument is: " + $args[0]
	"    Second positional function argument is: " + $args[1]

	"    First named function argument is: " + $argumentOne
	"    Second named function argument is: " + $argumentTwo
}

function GetArgumentsFunction3
{
	# Note, the param statement must be the first line, other than comments,
	# or it will not work.  Uncomment the next line to see what happens.
	#"  --Inside GetArgumentsFunction3 before param statement"

	param($argumentOne, $argumentTwo = 0)

	"  --Inside GetArgumentsFunction3 after param statement"
	# Display the arguments by position
	"    First positional function argument is: " + $args[0]
	"    Second positional function argument is: " + $args[1]
	# Display the arguments by name
	"    First named function argument is: " + $argumentOne
	"    Second named function argument is: " + $argumentTwo + 7
}

function GetArgumentsFunction4
{
	# Note, the param statement must be the first line, other than comments,
	# or it will not work.  Uncomment the next line to see what happens.
	#"  --Inside GetArgumentsFunction3 before param statement"

	param($argumentOne, [int] $argumentTwo = 0)

	[int] $x = $argumentTwo + 8
	"  --Inside GetArgumentsFunction4"
	# Display the arguments by position
	"    First positional function argument is: " + $args[0]
	"    Second positional function argument is: " + $args[1]
	# Display the arguments by name
	"    First named function argument is: " + $argumentOne
	"    Second named function argument is: " + $argumentTwo + 8
	"    X is: " + $x
}

# Call the internal functions with some arguments

""
">> Calling GetArgumentsFunction One Two"
GetArgumentsFunction One Two

""
">> Calling GetArgumentsFunction One Two One1 Two2"
GetArgumentsFunction One Two One1 Two2

""
">> Calling GetArgumentsFunction2 Three Four"
GetArgumentsFunction2 Three Four
""
">> Calling GetArgumentsFunction2 Three 4"
GetArgumentsFunction2 Three 4

""
">> Calling GetArgumentsFunction3 Five Six"
GetArgumentsFunction3 Five Six

""
">> Calling GetArgumentsFunction3 Five 6"
GetArgumentsFunction3 Five 6

""
">> Calling GetArgumentsFunction4 Seven 8"
GetArgumentsFunction4 Seven 8

$scriptBlock = 
{
    param($firstNamedArgument, [int] $secondNamedArgument = 0)
"  --Inside scriptBlock"
	"    First positional scriptblock argument is: " + $args[0]
	"    Second positional scriptblock argument is: " + $args[1]
    "    First named scriptblock argument is: $firstNamedArgument"
    "    Second named scriptblock argument is: $secondNamedArgument"
}

""
">> Calling scriptBlock"
& $scriptBlock -First Nine -Second 10.1

