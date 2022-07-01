function Get-HexDump {
    param (
        [Parameter(Mandatory)]
        [string]$path, 
        [int]$width=10, 
        [int]$total=-1
    )

    $OFS='' 
    Get-Content -Encoding byte -Path $path -ReadCount $width `
        -TotalCount $total | 
    foreach {       
        $record = $_
        if (($record -eq 0).count -ne $width)  
        {
            $hex = $record | %{  
                ' ' + ('{0:x}' -f $_).PadLeft(2,'0')} 
            $char = $record | %{  
                if ([char]::IsLetterOrDigit($_))  
                    { [char] $_ } else { '.' }}  
            "$hex $char"      
        }
    }
}
