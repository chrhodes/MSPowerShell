## Listing 8.3
$script:count = 0
$script:increment = 1
function Get-Count { return $script:count += $increment }

function Reset-Count { $script:count=0;  setIncrement 1 }
New-Alias reset Reset-Count  

function setIncrement ($x) {  $script:increment = $x }

Export-ModuleMember -Function *-Count -Variable increment -Alias reset 