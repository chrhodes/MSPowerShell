function Search-FilesInParallel
{
  param (
    [parameter(mandatory=$true, position=0)]
    $Pattern,

    [parameter(mandatory=$true, position=1)]
    [string[]]
    $Path,

    [parameter()]
    $Filter = "*.txt",

    [parameter()]
    [switch]
    $Any
)
  $jobid = [Guid]::NewGuid().ToString() 
  $jobs = foreach ($element in $path)
  {
    Start-Job -name "$Srch{jobid}" -scriptblock {
      param($pattern, $path, $filter, $any)
      Get-ChildItem -Path $path -Recurse -Filter $filter
      Select-String -list:$any $pattern 
    } -ArgumentList $pattern,$element,$filter,$any
  }
  Wait-Job -any:$any $jobs | Receive-Job 
  Remove-Job -force $jobs
}