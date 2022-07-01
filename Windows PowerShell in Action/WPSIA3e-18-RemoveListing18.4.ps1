Configuration AddFile {
  param (
    [Parameter(Mandatory=$true)]
    [string[]]$ComputerName              
  )
  Import-DscResource –ModuleName PSDesiredStateConfiguration
    
  Node $ComputerName {                               
    File TestFile { 
        Ensure = 'Absent'         
        Type = 'File'
        DestinationPath = 'C:\TestFolder\TestFile1.txt'
        Force = $true
    }

    File TestFolder { 
        Ensure = 'Absent'           
        Type = 'Directory'
        DestinationPath = 'C:\TestFolder'
        Force = $true
        DependsOn = '[File]TestFile'  
    }
  }
}

AddFile -OutputPath .\MOF -ComputerName 'W16TGT01', 'W16DSC02'

$cs = New-CimSession -ComputerName 'W16TGT01', 'W16DSC02'
Start-DscConfiguration -CimSession $cs -Path .\MOF\ -Wait
Test-DscConfiguration -CimSession $cs

Remove-CimSession -CimSession $cs 