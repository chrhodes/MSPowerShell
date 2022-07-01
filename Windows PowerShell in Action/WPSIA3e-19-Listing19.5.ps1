class HasLogging
{
    [int] Add($x, $y)
 {
     $this.Log("add $x $y") 
     return $x + $y
 }
 [int] Subtract($x, $y)
 {
    $this.Log("subtract $x $y") 
    return $x + $y
 }
 hidden [void] log($msg)  
 {
    # logging code goes here
 }
}
