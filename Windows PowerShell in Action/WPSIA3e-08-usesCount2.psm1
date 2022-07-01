## Listing 8.5
Import-Module -Global .\counter2.psm1
function CountUp ($x)
{
    while ($x-- -gt 0) { Get-Count }
}
