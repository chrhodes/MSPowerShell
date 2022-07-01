function Get-ProgId
{
    param (
        $filter = '.'
    )
    Get-ChildItem -Path 'REGISTRY::HKey_Classes_Root\clsid\*\progid' |
    foreach {if ($_.name -match '\\ProgID$') { $_.GetValue('') }} |
    Where-Object {$_ -match $filter}
}