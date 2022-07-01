## Listing 8.2
$script:count = 0
$script:increment = 1

function Get-Count    
{
    return $script:count += $increment
}

function Reset-Count  
{
    $script:count=0
    setIncrement 1
}

function setIncrement ($x)  
{
    $script:increment = $x
}

Export-ModuleMember *-Count   