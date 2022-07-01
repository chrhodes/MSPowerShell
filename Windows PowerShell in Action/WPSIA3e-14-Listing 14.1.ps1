function Show-ErrorDetails
{
    param(
        $ErrorRecord = $Error[0]  
    )
    
    $ErrorRecord | Format-List -Property * -Force     
    $ErrorRecord.InvocationInfo | Format-List -Property *   
    $Exception = $ErrorRecord.Exception  
    for ($depth = 0; $Exception -ne $null; $depth++)
    {   "$depth" * 80     
        $Exception | Format-List -Property * -Force  
        $Exception = $Exception.InnerException  
    }
}
