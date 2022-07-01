function New-Counter 
{
     param
     (
         [int]$increment = 1
     )

    $count=0;
    { 
        $script:count += $increment
        $count
    }.GetNewClosure()
}