function fls
{
    param (
        [Parameter()]
        [switch] 
            $New,
        [Parameter()]
        [int]
            $First = -1,
        [Parameter()]
        [switch]
            $NameOnly
    )

    $p = [PowerShell]::Create("CurrentRunspace").AddCommand("Get-ChildItem")
    if ($New)
    {
        [void] $p.AddCommand("Sort-Object").AddParameter("Descending").AddParameter("Property", "LastWriteTime")
    }
    if ($First -gt 0)
    {
        [void] $p.AddCommand("Select-Object").AddParameter("First", $First)
    }
    if ($NameOnly)
    {
        [void] $p.AddCommand("ForEach-Object").AddParameter("MemberName", "Fullname")
    }
    $p.Invoke()
    if ($p.HadErrors) 
    {
        $p.Streams.Errors
    }
}
