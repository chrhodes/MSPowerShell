class utils {

  static [int] $ISumTotal = 0 

  static [int] ISum([int[]] $na){
    $result = 0
    if ($na -eq $null -or $na.Length -eq 0) {
      return $result 
    }
    foreach ($n in $na) {
      $result += $n
    }
    [utils]::ISumTotal += $result
    return $result
  }

  [double] $DSumTotal = 0.0 

  [double] DSum([double[]] $da){
    $result = 0
    if ($da -eq $null -or $da.Length -eq 0) {
      return $result 
    }
    foreach ($n in $da) {
      $result += $n
    }
    $this.DSumTotal += $result
    return $result
  }
}
