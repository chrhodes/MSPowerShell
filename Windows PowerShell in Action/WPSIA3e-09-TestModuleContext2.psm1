$testv = 123
function Test-ModuleContext {
    [CmdletBinding()] param()
    "module testv is $testv"
    $ctestv = $PSCmdlet.SessionState.PSVariable.Get("testv").Value;
    "caller's testv is $ctestv"
}
