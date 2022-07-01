[DSCLocalConfigurationManager()]
Configuration LCM {	
	Param (
        [Parameter(Mandatory=$true)]
        [string[]]$ComputerName
    )

    Node $Computername
	{
		Settings  
		{
            ConfigurationMode = 'ApplyAndAutoCorrect'
            RebootNodeIfNeeded = $true		
		}
	}
}

LCM -computername W16TGT01 -OutputPath .\MOF