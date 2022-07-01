1..5 | foreach {
  Start-Job -name "job$_" -ScriptBlock {
    param($number)
    $waitTime = Get-Random -Minimum 4 -Maximum 10
    Start-Sleep -Seconds $waitTime
    "Job $number is complete; waited $waitTime"
  } -ArgumentList $_ > $null 
}
Wait-Job job* | Receive-Job