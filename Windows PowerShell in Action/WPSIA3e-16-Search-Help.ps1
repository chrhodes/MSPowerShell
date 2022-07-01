function Search-Help
{
    param (
        [Parameter(Mandatory)]
        $pattern
    )

    Select-String -List $pattern -Path $PSHome\en-us\about*.txt |
    foreach {$_.filename -replace '\..*$'}

    Get-ChildItem $PSHOME\en-us\*dll-help.*xml |
    foreach { [xml] (Get-Content -ReadCount -1 -Path $_) } |
    foreach{$_.helpitems.command} |
    Where-Object {$_.get_Innertext() -match $pattern} |
    foreach {$_.details.name.trim()}
}
