workflow is1 {
    parallel {
        'BootTime from Parallel:'
        Get-CimInstance -ClassName Win32_OperatingSystem -PSComputerName $env:COMPUTERNAME | 
        Select-Object -ExpandProperty LastBootUpTime 
        
        InlineScript {
            $os = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $env:COMPUTERNAME
            'BootTime from InlineScript: '
             $($os.ConvertToDateTime($os.LastBootUpTime))
        }
    }
}
is1