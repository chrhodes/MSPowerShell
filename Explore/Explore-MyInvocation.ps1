">>> MyInvocation.InvocationName"
$MyInvocation.InvocationName
"<<<"
">>> MyInvocation.MyCommand"
$MyInvocation.MyCommand | Format-List -Property * -Verbose
"<<<"
">>> MyInvocation.MyCommand.Module"
$MyInvocation.MyCommand.Module | Format-List -Property *
"<<<"

">>> MyInvocation.PSCommnandPath"
$MyInvocation.PSCommandPath
"<<<"
">>> MyInvocation.PSScriptRoot"
$MyInvocation.PSScriptRoot
"<<<"
">>> MyInvocation.ScriptName"
$MyInvocation.ScriptName
"<<<"
">>> MyInvocation.PSCommnandPath"
$MyInvocation.PSCommnandPath
"<<<"
