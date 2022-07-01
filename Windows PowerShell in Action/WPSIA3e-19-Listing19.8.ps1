class utils {

   [int] Sum([int[]] $na){
    $result = 0
    if ($na -eq $null -or $na.Length -eq 0) {
      return $result 
    }
    foreach ($n in $na) {
      $result += $n
    }
    return $result
  }
  
} 

class newutils : utils { 

    [double] Sum([double[]] $na){
    $result = 0
    if ($na -eq $null -or $na.Length -eq 0) {
      return $result 
    }
    foreach ($n in $na) {
      $result += $n
    }
    return $result
  }
  
}
