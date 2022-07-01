class utils {

  static [int] ISum([int[]] $na){
    $result = 0
    if ($na -eq $null -or $na.Length -eq 0) {
      return $result 
    }
    foreach ($n in $na) {
      $result += $n
    }
    return $result
  }

  [double] DSum([double[]] $da){
    $result = 0
    if ($da -eq $null -or $da.Length -eq 0) {
      return $result 
    }
    foreach ($n in $da) {
      $result += $n
    }
    return $result
  }

}
