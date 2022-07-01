function Get-Type {
    [CmdletBinding()]
    param (
        [string]$Pattern='.'
    )
    [System.AppDomain]::CurrentDomain.GetAssemblies() |
    Sort-Object FullName |
    foreach{ 
        $asm = $psitem
        Write-Verbose $asm.Fullname
 
        switch ($asm.Fullname) {
            {$_ -like 'Anonymously Hosted DynamicMethods Assembly*'}{break}
            {$_ -like 'Microsoft.PowerShell.Cmdletization.GeneratedTypes*'}{break}
            {$_ -like 'Microsoft.Management.Infrastructure.UserFilteredExceptionHandling*'}{break}
            {$_ -like 'Microsoft.GeneratedCode*'}{break}
            {$_ -like 'MetadataViewProxies*'}{break}
            default {
                $asm.GetExportedTypes() | 
                Where-Object {$_ -match $Pattern} |
                Select-Object @{N='Assembly'; E={($_.Assembly -split ',')[0]}},
                IsPublic, IsSerial,FullName, BaseType
            }
        }
    }
}