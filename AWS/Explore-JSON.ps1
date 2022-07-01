cd 'C:\users\crhodes\My Drive\Budget & Costs'

$myJson = Get-Content .\github_chrhodes_repos.json -Raw | ConvertFrom-Json
$releases = Get-Content .\github_powershell_releases.json -Raw | ConvertFrom-Json

$releases

$releases | get-member

$releases.name
$releases.assets
$releases.assets.name



