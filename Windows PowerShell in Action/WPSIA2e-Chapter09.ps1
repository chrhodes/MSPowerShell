############################################################
#
# Windows PowerShell in Action Chapter 9
# 
# Using and authroing modules
#
#
# 9.1 The role of a module system
#
# 9.2 Module basics
#
# 9.3 Working with modules
#
# 9.4 Writing script modules
#
# 9.5 Binary modules
#
############################################################

# 9.1 The role of a module system

# 9.1.1 Module roles in PowerShell

# 9.1.2 Module mashups: composing and application

# 9.2 Module basics

# 9.2.1 Module terminology

# 9.2.2 Modules are single-instance objects

# 9.3 Working with modules

# 9.3.1 Finding modules on the system

# 9.3.2 Loading a module

# 9.3.3 Removing a loaded module

# 9.4 Writing script modules

# 9.4.1 A quick review of scripts

# Run WPSIA-Chapter09-Counter.ps1
. .\WPSIA-Chapter09-Counter.ps1
Get-Command *-count

Get-Count
Get-Count
Reset-Count
Get-Count

Get-Command setIncrement

setIncrement 7
Get-Count
Get-Count

Get-Variable

Get-Variable count, increment

Remove-Item -Verbose variable:count, variable:increment, 
    function:Reset-Count, function:Get-Count, function:setIncrement


# 9.4.2 Turning a script into a module

# 9.4.3 Controlling member visibility with Export-ModuleMember

# 9.4.4 Installing a module

# 9.4.5 How scopes work in script modules

# 9.4.6 Nested modules

# 9.5 Binary modules

# 9.5.1 Binary modules versus snap-ins

# 9.5.2 Creating a binary module

# 9.5.3 Nesting binary modules in script modules

# 9.6 Summary

