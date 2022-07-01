function test-paging {
    [CmdletBinding(SupportsPaging=$true)]
    param()
    
    $firstnumber = [math]::Min($pscmdlet.PagingParameters.Skip, 20)
    $lastnumber = [math]::Min($pscmdlet.PagingParameters.First + $firstnumber -1, 20)
    
    if ($pscmdlet.PagingParameters.IncludeTotalCount){
        $totalcountaccuracy = 1.0
        $totalcount = $pscmdlet.PagingParameters.NewTotalCount(20, $totalcountaccuracy)
        Write-Output $totalcount
    }
    $firstnumber..$lastnumber | Write-Output
}