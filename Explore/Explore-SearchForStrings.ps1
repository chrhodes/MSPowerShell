cdget-content source.txt | % {$_.Split('|') | select -last 1 }

cd C:\temp\CumminsWI\2017.09.06
cd C:\temp\CumminsWI\2017.09.06
cd C:\temp\CumminsWI\CumminsWI_13Sep2017
cd C:\temp\CumminsWI\CumminsWI1_13Sep2017


$logfile = "CumminsWI.log"
$logfile = "CumminsWI0001.log"
$logfile = "CumminsWI.2017-09-09.log"

$logfile = "CumminsWI.2017-09-150001.log"

select-string -path $logfile -Pattern '7.7.14.9'

select-string -path $logfile -Pattern 1002 | % { $_.Split('|') }

get-content $Logfile | % { $_.Split('|') }

get-content $Logfile | % { $_.Split('|') | select -last 3 }

get-content $Logfile | % { $_.Split("|") | select -last 1 } | select-string -Pattern "strSQL" | select-string -Pattern "select"

get-content $logfile | % { $_.Split("|").GetType() } | select -last 2 } | select-string -Pattern "^strSQL" | select-string -Pattern "select" | Out-File -Width 1000 SQLStatements.txt

Get-Content $logfile | % { if ($_.Split("|")[2] -eq "1002") { $_; }} | % { $_.Split("|")  | select -last 3 }

select-string -path $logfile -Pattern "CheckEngineAbstractTable"

Get-Content $logfile | % { if ($_.Split("|")[2] -eq "1002") { $_; }} | % { if ($_.Split("|")[11] -gt 0.1) { $_; }} | % { $_.Split("|")  | select -last 3 }

get-content 

Get-ChildItem -Path C:\Source-Ease-Main -Recurse -Include "frmMessageBox.vb" | select-string -Pattern "Const LOG_APPNAME"
Get-ChildItem -Path C:\Source-Ease-Main -Recurse -Include "*.vb" | select-string -Pattern "Const LOG_APPNAME"

Get-Content $logfile | % { if ($_.Split("|")[11] -gt 5.0) { $_; }} 

Get-Content $logfile | % { if ($_.Split("|")[2] -eq "1002" -or $_.Split("|")[11] -gt 0.1) { $_; } } 

Get-Content $logfile | % { if ($_.Split("|")[2] -eq "1002" -or $_.Split("|")[11] -gt 0.1) { $_; } } 

# Look for Errors

Get-Content $logfile | % { if ($_.Split("|")[2] -eq "-1") { $_; } } 

# Look for Debug2 lines

Get-Content $logfile | % { if ($_.Split("|")[2] -eq "1002") { $_; } }

# Look for ApplicationStart lines

Get-Content $logfile | % { if ($_.Split("|")[10] -eq "modCummins1.ApplicationStart") { $_; } }


# Look for SessionStart lines

Get-Content $logfile | % { if ($_.Split("|")[10] -eq "modCummins1.SessionStart") { $_; } }

$logfiles = Get-ChildItem CumminsWI0[0-9][0-9][0-9].log

$logfiles = Get-ChildItem CumminsWI*.log


$logfiles = Get-ChildItem *CumminsWI*.log

$logfiles = Get-ChildItem CumminsWI.2017-09-[0-9][0-9].log

$logfiles = Get-ChildItem CumminsWI.log

$logfiles = Get-ChildItem *CumminsWI.log

$logfiles = Get-ChildItem CumminsWI.2017-09-150001.log
$logfiles = Get-ChildItem CumminsWI1.2017-09-15.log

$logfiles

foreach ($file in $logFiles)
{
    "Processing $file"

    "  Gathering Debug2"
    Get-Content $file | % { if ($_.Split("|")[2] -eq "1002") { $_; } } > "$file - Debug2.log"

    "  Gathering Error"
    Get-Content $file | % { if ($_.Split("|")[2] -eq "-1") { $_; } } > "$file - Error.log"
}

foreach ($file in $logFiles)
{
    "Processing $file"

    "  Gathering Debug2"
    Get-Content $file | % { if ($_.Split("|")[2] -eq "1002") { $_; } } > "$file - Debug2.log"

    "  Gathering Error"
    Get-Content $file | % { if ($_.Split("|")[2] -eq "-1") { $_; } } > "$file - Error.log"
}

foreach ($file in $logFiles)
{
    "Processing $file"

    "  Gathering SessionStart"
    Get-Content $file | % { if ($_.Split("|")[10] -eq "modCummins1.SessionStart") { $_; } } > "$file - SesionStart.log"
    # Get-Content $file | % { if ($_.Split("|")[10] -eq "modCummins1.SessionStart") { $_; } } | Out-File "$file - SesionStart.log" -Encoding utf7

    "  Gathering ApplicationStart"
    Get-Content $file | % { if ($_.Split("|")[10] -eq "modCummins1.ApplicationStart") { $_; } } > "$file - ApplicationStart.log"

    "  Gathering RestartAPP"
    Get-Content $file | % { if ($_.Split("|")[10] -eq "modCummins1.RestartAPP") { $_; } } > "$file - RestartAPP.log"
}

foreach ($file in $logFiles)
{
    "Processing $file"

    "  Gathering modCumminsMRC.GetFirstStationInLine"
    Get-Content $file | % { if ($_.Split("|")[10] -eq "modCumminsMRC.GetFirstStationInLine") { $_; } } > "$file - GetFirstStationInLine.log"
}

foreach ($file in $logFiles)
{
    Get-Content $file | % { if ($_.Split("|")[10] -eq "modCummins1.ApplicationStart") { $_; } } > "$file - ApplicationStart.log"
}


foreach ($file in $logFiles)
{
    Get-Content $file | % { if ($_.Split("|")[10] -eq "modCummins1.RestartAPP") { $_; } } > "$file - RestartAPP.log"
}

foreach ($file in $logFiles)
{
    Get-Content $file | % { if ($_.Split("|")[10] -eq "frmEngineUpdate.Page_Load") { $_; } } > "$file - frmEngineUpdate.log"
}

foreach ($file in $logFiles)
{
    "Processing $file"

    "  Gathering SlowCalls"
    Get-Content $logfile | % { if ($_.Split("|")[11] -gt 5.0) { $_; } } > "$file - SlowCalls.log"
}


$debuglogfiles = Get-ChildItem CumminsWI0[0-9][0-9][0-9]*debug*.log
foreach ($file in $debuglogFiles)
{
    Get-Content $file >> "Cummins-Debug2.log"
}

$errorlogfiles = Get-ChildItem CumminsWI0[0-9][0-9][0-9]*error*.log
foreach ($file in $errorlogFiles)
{
    Get-Content $file >> "Cummins-Error.log"
}

cd "D:\Cummins Logs\CumminsWI.2017-09-15\"
$logfiles = Get-ChildItem CumminsWI.2017-09-15.log

cd "C:\temp\CumminsWI\CumminsWI.2017-09-15\"

cd "C:\temp\CumminsWI\CumminsWI_2017Sep26\"
cd "C:\temp\CumminsWI\CumminsWI1_2017Sep26\"
$logfiles = Get-ChildItem CumminsWI*.log


foreach ($file in $logFiles)
{
    Get-Content $file | % { if ($_.Split("|")[10] -ne "stdMod3.CheckForErrors") { $_; } } > "$file - NoCheckForErrors.log"
}

foreach ($file in $logFiles)
{
    "Processing $file"

    "  Gathering frmEngineUpdate.CheckEngineStationRecordExist"
    Get-Content $file | % { if ($_.Split("|")[10] -eq "frmEngineUpdate.CheckEngineStationRecordExist") { $_; } } > "$file - frmEngineUpdate.CheckEngineStationRecordExist.log"
}

