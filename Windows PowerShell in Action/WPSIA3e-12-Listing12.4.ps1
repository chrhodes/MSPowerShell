workflow fe {
    'Do loop'
    $i = 1
    $j = @()
    do {
        $j += $i
        $i++
    } while ($i -le 10)
    "$j"
    
    'While loop'
    $i = 1
    $j = @()
    while ($i -le 10) {
        $j += $i
        $i++
    } 
    "$j"
    
    'For loop'
    $j = @()
    for ($i = 1; $i -le 10; $i++) {
        $j += $i

    } 
    "$j"
    
    'Foreach loop'
    $j = @()
    foreach ($i in 1..10){$j += $i}
    "$j"
}
fe