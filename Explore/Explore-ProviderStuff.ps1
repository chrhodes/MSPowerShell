# PowerShell Providers
#

# Get list of PS Providers(Drives)

Get-PSDrive

# Resist the urge to run this as some providers have lots of output :)

foreach ($psd in (Get-PSDrive | Select-Object -Property Name))
{
    $p = $psd.Name + ":"

    "Getting Items from $p"

    Get-Item $p
}

Get-Item -Path GAC: | Select-Object Microsoft*

foreach($ap in (Get-ChildItem AppPools))
{
    #$ap1 = "IIS:\AppPools\($ap.Name)"
    $ap1 = "IIS:\AppPools\" + $ap.Name
    $ap1
    (Get-Item $ap1).Attributes | Format-Table Name, Value
    #(Get-Item "IIS:\AppPools\($ap.Name)").Attributes | gm
}