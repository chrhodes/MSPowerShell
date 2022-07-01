$sb = {
    $a = [char[]] $this
    [array]::reverse($a)
    -join $a
}
