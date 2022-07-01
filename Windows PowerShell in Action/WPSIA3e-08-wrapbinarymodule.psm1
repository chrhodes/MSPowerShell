## Listing 8.7
param (
    [bool] $showCmdlet
)

Import-Module $PSScriptRoot\ExampleModule.dll -Verbose

function wof
{
    param ($o = "Hi there")
    Write-InputObject -InputObject $o
}

if ($showCmdlet)
{
    Export-ModuleMember -Cmdlet Write-InputObject
}
else
{
    Export-ModuleMember -Function wof
}
