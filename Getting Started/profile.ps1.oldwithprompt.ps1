# Force variable declaration before use
Set-PsDebug -Strict

#
# Change the prompt
#

function Prompt
{
    $id = 1
    # Get the last item from the history
    $historyItem = Get-History -Count 1
    
    if($historyItem)
    {
        # Get the training suggestions for that item
        $suggestions = @(Get-AliasSuggestion $historyItem.CommandLine)

        # If there were any suggestions
        
        if($suggestions)
        {
           # For each suggestion, write it to the screen
           foreach($aliasSuggestion in $suggestions)
           {
               Write-Host "$aliasSuggestion"
           }
           Write-Host ""
        }

        # Bump the history counter
        $id = $historyItem.Id + 1
    }

    Write-Host -ForegroundColor DarkGray "`n[$(Get-Location)]"
    Write-Host -NoNewLine "PS:$id > "
    $host.UI.RawUI.WindowTitle = "$(Get-Location)"

    "`b"
#    "PS [$env:COMPUTERNAME] >"
}

Set-Alias gh Get-Help
$MaximumHistoryCount=256
function Get-HistoryAll {Get-History -count $MaximumHistoryCount | sort -desc | Out-Host -Paging}
Set-Alias ghy+ Get-HistoryAll
$env:PSModulePath = $env:PSModulePath + ";B:\bin\PowerShell\Modules"
Import-Module B:\bin\PowerShell\Modules\VNCPowerShell.psm1 -WarningAction Ignore
set-alias -Name n+ -Value "C:\Program Files\Notepad++\notepad++.exe"

