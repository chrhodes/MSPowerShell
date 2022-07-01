[DSCLocalConfigurationManager()]
Configuration LCMpull {
  param (
    [Parameter(Mandatory=$true)]
    [string[]]$ComputerName,

    [Parameter(Mandatory=$true)]
    [string]$guid,  

    [Parameter(Mandatory=$true)]
    [string]$ThumbPrint  

  )      	
  Node $ComputerName {
	Settings {
      AllowModuleOverwrite = $True
      ConfigurationMode = 'ApplyAndAutoCorrect'
      RefreshMode = 'Pull' 
      ConfigurationID = $guid 
    }

    ConfigurationRepositoryWeb DSCHTTPS {
       ServerURL = 'https://W16DSC02:8080/PSDSCPullServer.svc'
       CertificateID = $thumbprint  
       AllowUnsecureConnection = $false  
    }

    ReportServerWeb RepSrv {
       ServerURL = 'http://W16DSC02:9080/PSDSCPullServer.svc'
       CertificateID = 'AllowUnencryptedTraffic'  
       AllowUnsecureConnection = $true 
    }

  }
}

#$guid = New-Guid | select -ExpandProperty Guid
$guid = '5827c542-20bb-487c-89cb-484cbe5f0b1f'

$thumbprint=Invoke-Command -Computername W16DSC02 {
Get-Childitem Cert:\LocalMachine\My | 
where Subject -Like 'CN=W16DSC02*' | 
Select-Object -ExpandProperty ThumbPrint}

LCMpull -computername W16TGT01 -Guid $guid -Thumbprint $thumbprint -OutputPath .\MOF