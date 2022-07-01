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

   [int] Sum([int[]] $na){
    $result = 0
    if ($na -eq $null -or $na.Length -eq 0) {
      return $result 
    }
    $result = 1 
    foreach ($n in $na) {
      $result *= $n 
    }
    return $result
  }  
}
