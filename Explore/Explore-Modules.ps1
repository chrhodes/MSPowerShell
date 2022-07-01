# PowerShell env

$env:PSModulePath

# Display Installed Modules

Get-Module

# List Available Modules

Get-Module -ListAvailable

# 

Get-Module -All


# List All Available Modules

Get-Module -ListAvailable -All

# Import a module so it can be used

Import-Module <moduleName>

# Get all commands in module

Get-Command -Module <moduleName>

# Create some files showing what commands are in each (loaded) module

foreach($mod in (Get-Module | Select-Object Name))
{
    $nm = $mod.Name
    Get-Command -module $mod.Name > C:\temp\PS-$nm.txt
}


(Get-Module -ListAvailable ZLocation).path