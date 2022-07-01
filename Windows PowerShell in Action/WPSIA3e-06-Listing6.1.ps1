$characterData = @{  
  'Linus' = @{ age = 8; human = $true}
  'Lucy' = @{ age = 8; human = $true}
  'Snoopy' = @{ age = 2; human = $true}
}

function Get-Character ($name = '*')
{
  foreach ($entry in $characterData.GetEnumerator() | Write-Output) 
  {
    if ($entry.Key -like $name)
    {
        $properties = @{ 'Name' = $entry.Key } + $entry.Value
        New-Object PSCustomObject -Property $properties 
     }
  }
}

function Set-Character { 
  process {
    $characterData[$_.name] =
      @{
        age = $_.age
        human = $_.human
      }
   }
}

function Update-Character (                                          
  [string] $name = '*',
  [int] $age,
  [bool] $human
)
{
  begin
  {
    if ($PSBoundParameters.'name')                                  
    {
      $name = $PSBoundParameters.name
      [void] $PSBoundParameters.Remove('name')                      
    }
  }
  process
  {  
    if ($_.name -like $name)                                        
    {
      foreach ($p in $PSBoundParameters.GetEnumerator())
      {
        $_.($p.Key) = $p.value 
      }
    }
    $_
  }
}
