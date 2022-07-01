$dt = @{
  '3' = 'Fixed'
  '5' = 'CD-Rom'
}

$hlth = @{
 '0' = 'Healthy'
 '1' = 'Scan Needed'
 '3' = 'Full Repair Needed'
}

if ($IsCoreCLR) {
  if ($IsLinux){
    df -T 
  }
  elseif ($IsWindows) {
    Get-CimInstance -Namespace 'ROOT/Microsoft/Windows/Storage' `
    -ClassName MSFT_Volume |
    select DriveLetter, FileSystemLabel, FileSystem, 
    @{N='DriveType'; E={$dt["$($_.DriveType)"]}}, 
    @{N='HealthStatus'; E={$hlth["$($_.HealthStatus)"]}},  
    @{N='SizeRemaining(GB)'; E={[math]::Round($_.SizeRemaining / 1GB, 2)}}, 
    @{N='Size(GB)'; E={[math]::Round($_.Size / 1GB, 2)}}
  }
}
else {
  Get-Volume  
}
