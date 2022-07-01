function fscope {
  Import-Module C:\testmodule\ScopeTest -RequiredVersion 1.1.0 -Scope Local -Force
  Write-Information "`n In function" -InformationAction Continue
  hello
}

Write-Information "`n In Script" -InformationAction Continue
Import-Module C:\testmodule\ScopeTest -RequiredVersion 1.0.0 -Scope Global -Force
hello

Write-Information "`n Moving to function" -InformationAction Continue
fscope

Write-Information "`n Back in Script and Finish" -InformationAction Continue
hello