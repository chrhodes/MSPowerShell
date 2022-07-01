function New-Point
{
    New-Module -ArgumentList $args -AsCustomObject {
        param (
            [int] $x = 0,
            [int] $y = 0
        )
        function ToString()
        {
           "($x, $y)"
        }
        Export-ModuleMember -Function ToString -Variable x,y
    }
}