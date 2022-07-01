workflow Invoke-ParallelForEach  
{ 
    foreach -parallel ($i in 1..10)  
    { 
        InlineScript  
        { 
            "foo: $using:i" 
        } 
        $count = Get-Process -Name PowerShell* | 
                 Measure-Object | 
                 Select-Object -ExpandProperty Count
        "Number of PowerShell processes = $count"  
    } 
}
$startcount = Get-Process -Name PowerShell* |  
                 Measure-Object | 
                 Select-Object -ExpandProperty Count           
"Number of starting PowerShell processes = $startcount"    
Invoke-ParallelForEach   