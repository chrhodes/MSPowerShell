function Read-ModuleManifest {
    param
    (
        [Object]$manifestPath
    )

    try {
        $fullpath = Resolve-Path $manifestPath -ErrorAction Stop 
        if (Test-ModuleManifest $fullPath) 
        {
            $parentpath = Split-Path -Parent $fullPath                #A
            $content = (Get-Content $fullPath) -Join "`n"
            Invoke-Expression $($content.Replace('$psScriptRoot', '$parentpath'))      #B                            #B
        }
        
    }
    catch {break}
} 