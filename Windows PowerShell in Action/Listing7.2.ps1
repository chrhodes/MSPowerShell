function Test-ParameterSets {
  param (
    [parameter(ParameterSetName='s1')] $p1='p1 unset',
    [parameter(ParameterSetName='s2')] $p2='p2 unset',
    [parameter(ParameterSetName='s1')]
    [parameter(ParameterSetName='s2',Mandatory=$true)]
    $p3='p3 unset',
    $p4='p4 unset'
  )
  'Parameter set = ' + $PSCmdlet.ParameterSetName
  "p1=$p1 p2=$p2 p3=$p3 p4=$p4"
}