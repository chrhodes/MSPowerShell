# https://docs.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-string-substitutions?view=powershell-7.2

$directory = Get-Item 'c:\windows'
$directory
$directory.GetType()
$directory | Get-Member

$directory.CreationTime
$directory.LastWriteTime


$message = "CreationTime: $directory.CreationTime"
$message = "CreationTime: " + $directory.CreationTime
$message = "CreationTime: $($directory.CreationTime)"
$message = "CreationTime: $directory.CreationTime LastWriteTime: $directory.LastWriteTime"
$message = "CreationTime: " + $directory.CreationTime # LastWriteTime: $directory.LastWriteTime"
$message = "CreationTime: " + $directory.CreationTime + "LastWriteTime: " +  $directory.LastWriteTime

$message = "CreationTime: $($directory.CreationTime) LastWriteTime: $($directory.LastWriteTime)"

$message