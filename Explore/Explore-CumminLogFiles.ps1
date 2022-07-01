CD 'C:\Customers\Cummins\Log Files'
cd CumminsWI_16Nov2017
$logfile = "CumminsWI.log"
$logfile = "CumminsWI.log"

$pattern = "modCummins3.DisableMenuButton"
$pattern = "modCDC.WriteToLogFile"
$pattern = "modCummins1.GetStationRangeFromMemory"
$pattern = "mod_GenlFunctions.GettheValueFromCookie"
#$pattern = "modCummins3.DisableMenuButton"
#$pattern = "modCummins3.DisableMenuButton"
#$pattern = "modCummins3.DisableMenuButton"
#$pattern = "modCummins3.DisableMenuButton"

$logfile = "CumminsWI.log"
$pattern = "modCummins1.GetStationRangeFromMemory"

Get-Content $logfile | % { if ($_.Split("|")[10] -ne $pattern) { $_; } } > "$logfile - A1"

$logfile = "CumminsWI.log - A1"
$pattern = "mod_GenlFunctions.GettheValueFromCookie"
Get-Content $logfile | % { if ($_.Split("|")[10] -ne $pattern) { $_; } } > "$logfile - A2"