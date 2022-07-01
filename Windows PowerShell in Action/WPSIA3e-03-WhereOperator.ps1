##  Chapter 3 PowerShell in Action third edition
##  Section 3.6.1

## where operator / where method
# introduced with PowerShell v4

Get-Process | where Handles -gt 1000

## use WHERE method - need $_ or $psitem
(Get-Process).where({$_.Handles -gt 1000})

(Get-Process).where({$psitem.Handles -gt 1000})

## can be used without () but recommend they should be used
(Get-Process).where{$psitem.Handles -gt 1000}

## display first and last results
(Get-Process).where({$_.Handles -gt 1000}, 'First')
(Get-Process).where({$_.Handles -gt 1000}, 'Last')

## display first & last N results
(Get-Process).where({$_.Handles -gt 1000}, 'First', 3)
(Get-Process).where({$_.Handles -gt 1000}, 'Last', 3)

## Split
$proc = (Get-Process).where({$_.Handles -gt 1000}, 'Split')
## processes matching filter
$proc[0]
## processes not matching filter
$proc[1]

## all results
(Get-Process | sort Handles).where({$_.Handles -gt 1000})

## display results until reach results matching filter
(Get-Process | sort Handles).where({$_.Handles -gt 1000}, 'Until')

## only display results that match filter
(Get-Process | sort Handles).where({$_.Handles -gt 1000}, 'SkipUntil')

## without sort displays everything AFTER first result matching filter
(Get-Process ).where({$_.Handles -gt 1000}, 'Until')  

## without sort displays first 3 results AFTER first result matching filter
(Get-Process ).where({$_.Handles -gt 1000}, 'SkipUntil', 3) 