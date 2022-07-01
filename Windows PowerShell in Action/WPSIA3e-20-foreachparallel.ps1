$pool = [runspacefactory]::CreateRunspacePool(1, 3) 
$pool.Open()
$tasks = foreach ($i in 1 .. 10) 
{
    $p = [PowerShell]::Create()
    $p.RunspacePool = $pool
    $p = $p.AddScript{ 
        param ($iteration)

        foreach ($i in 1..5)
        {
            [console]::WriteLine("*" * ($iteration * 2)) 
            Start-Sleep -Milliseconds 200
        }
        if ($iteration -eq 3)  
        {
            Write-Error "ITERATION ERROR"
        }
    }.AddArgument($i)
    $ia = $p.BeginInvoke()
    @{p=$p; ia=$ia; iteration=$i} 
}
foreach ($t in $tasks)
{
    $t.p.EndInvoke($t.ia)
    if ($t.p.HadErrors)   
    {
        Write-Error "Task iteration $($t.iteration) had errors"
        $t.p.Streams.Errors
    }
    $t.p.Dispose()
}
