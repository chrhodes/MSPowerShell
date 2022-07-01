############################################################
#
# Windows PowerShell in Action Chapter 7
# 
# PowerShell functions
#
# 7.1 Fundamentals of PowerShell functions
#
# 7.2 Declaring formal parameters for a function
#
# 7.3 Returning values from functions
#
# 7.4 Using simple functions in a pipeline
# 
# 7.5 Managing function definitions in a session
#
# 7.6 Variable scoping in functions
#
############################################################

# 7.1 Fundamentals of PowerShell functions

# 7.1.1 Passing arguments using $args

# 7.1.2 Example functions: ql and qs

# 7.1.3 Simplifying $args processing with multiple assignment

# 7.2 Declaring formal parameters for a function

# 7.2.1 Mixing named and positional arguments

# 7.2.2 Adding type constraints to parameters

# 7.2.3 Handling variable numbers of arguments

# 7.2.4 Initializing function parameters with default values

# 7.2.5 Handling mandatory parameters, v1-style

# 7.2.6 Using switch parameters to define command switches

# 7.2.7 Switch parameters vs. Boolean parameters

# 7.3 Returning values from functions

# 7.3.1 Debugging problems in function output

# 7.3.2 The return statement

# 7.4 Using simple functions in a pipeline

# 7.4.1 Filters and functions

# 7.4.2 Functions with begin, process, and end blocks

function foo($x)
{
    begin
    {
        $c = 0;
        "In Begin, c is $c, x is $x" 
    }
    process
    {
        $c++
        "In Process, c is $c, x is $x, `$_ is $_"
    }
    end
    {
        "In End, c is $c, x is $x"
    }
}

# 7.5 Managing function definitions in a session

# 7.6 Variable scoping in functions

# 7.6.1 Declaring variables

# 7.6.2 Using variable scope modifiers

# 7.7 Summary