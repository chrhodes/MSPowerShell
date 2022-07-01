Configuration EnvVarConfig {
  param (
    [string]$ComputerName
  )

  Import-DscResource -ModuleName PSDesiredStateConfiguration

  Node $ComputerName {
    Environment EnvironmentPC {
      Ensure = 'Present'
      Name = 'PCtestvar'
      Value = 'PIA 3e'
    }
  }
}

EnvVarConfig -ComputerName W16CN01 -OutputPath .\MOF\Env\