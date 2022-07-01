Configuration RegConfig {
  param (
    [string]$ComputerName
  )

  Import-DscResource -ModuleName PSDesiredStateConfiguration

  Node $ComputerName {
    Registry RegistryPC {
      Ensure = 'Present'
      Key = 'HKEY_LOCAL_MACHINE\SOFTWARE\RegTestKey'
      Valuename = 'PCTestVar'
      ValueData = 'PIA 3e'
      ValueType = 'String'
    }
  }
}

RegConfig -ComputerName W16CN01 -OutputPath .\MOF\Reg\