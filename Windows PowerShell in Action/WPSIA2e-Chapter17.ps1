############################################################
#
# Windows PowerShell in Action Chapter 11
#
# Extending your reach with .NET
# 
# 17.1 Using .NET from PowerShell
#
# 17.2 PowerShell and the Internet
#
# 17.3 PowerShell and graphical user interfaces
# 
############################################################
#
# 17.1.3 Finding Types

function Get-Assembly
{
    [System.AppDomain]::CurrentDomain.GetAssemblies()
}

function Get-Type ($Pattern=".")
{
    # Need to enhance this to ignore dynamic assemblies

    Get-Assembly | ForEach-Object { $_.GetExportedTypes() } |
        Where-Object { $_ -match $Pattern }
}

# Find all types that have prefix System.Timers

Get-Type ^system\.timers | % { $_.FullName }

# Create some filters to show members in a nicely formatted way

filter Select-Member ($Pattern = ".")
{
    $_.GetMembers() | Where-Object { $_ -match $Pattern }
}

filter Show-Member ([switch] $Method)
{
    if ( ! $Method -or $_.MemberType -match "method")
    {
        "[{0}]:: {1}" -f $_.declaringtype, $_
    }
}

Get-Type ^system\.timers | Select-Member begin | Show-Member -method

# Load the WPF assemblies
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName PresentationFramework
# Need to figure out why this isn't working
#Add-Type -AssemblyName PacificLife.Life.PLLog

# 17.2 PowerShell and the internet
#
# 17.3 PowerShell and graphical user interfaces
#