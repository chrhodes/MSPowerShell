$mInfo = $MyInvocation.MyCommand.ScriptBlock.Module
$mInfo.OnRemove = {
        Write-Host "I was removed on $(Get-Date)"
    }