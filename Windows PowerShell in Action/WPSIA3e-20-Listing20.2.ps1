$r = [runspacefactory]::CreateRunspace() 
$r.Open()

$p = [PowerShell]::Create().AddScript{ 
    foreach ($i in 1..4) {
        [console]::WriteLine(">>> BACKGROUND $i")
        Start-Sleep 1
    }
    [console]::WriteLine("Background is done")
}

$p.Runspace = $r
$a = $p.BeginInvoke() 
foreach ($i in 1..3) {
    [console]::WriteLine("foreground $i <<<")
    Start-Sleep 1
}
[console]::WriteLine("Foreground is done")

$p.EndInvoke($a)   
"Called EndInvoke."