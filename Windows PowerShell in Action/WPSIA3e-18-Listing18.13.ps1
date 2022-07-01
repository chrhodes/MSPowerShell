[DSCLocalConfigurationmanager()]
Configuration PCTest1 {
  param (
    [string]$ComputerName
  )

  Node $ComputerName {
     PartialConfiguration EnvVarConfig {
       Description = 'Sets the environmental variable'
       RefreshMode = 'Push'
     }

     PartialConfiguration RegConfig {
       Description = 'Sets the registry key'
       RefreshMode = 'Push'
     }
  }
}

PCTest1 -ComputerName W16CN01 -OutputPath .\MOF