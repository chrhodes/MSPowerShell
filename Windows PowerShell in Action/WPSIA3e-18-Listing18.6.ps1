$ConfigurationData = @{
  AllNodes = @(
    @{NodeName = 'W16TGT01';Role = 'Hyper-V'},
    @{NodeName = 'W16CN01';Role = 'AD'}
  )
}

Configuration RoleConfiguration
{
  param ($Role)
  switch ($Role) {
    'Hyper-V' {
        Import-DscResource -ModuleName PSDesiredStateConfiguration
        WindowsFeature Hyper-V {
            Ensure = 'Present'
            Name = 'Hyper-V-PowerShell'
        }
    }     
    'AD' {
        Import-DscResource -ModuleName PSDesiredStateConfiguration
        WindowsFeature AD {
            Ensure = 'Present'
            Name = 'RSAT-AD-PowerShell'
        } 
    }
 }
}

Configuration ToolsConfig 
{
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    node $allnodes.NodeName
    {
        RoleConfiguration ServerRole
        {
        	Role = $Node.Role
    	}
    }
}

ToolsConfig -ConfigurationData $ConfigurationData -OutputPath .\MOF