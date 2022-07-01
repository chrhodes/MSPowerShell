Configuration AddFile {
  param (
    [Parameter(Mandatory=$true)]
    [string[]]$ComputerName  
  )
  Import-DscResource –ModuleName PSDesiredStateConfiguration
    
  Node $ComputerName { 
 
    File TestFile {                             
        Ensure = 'Present'
        Type = 'File'
        DestinationPath = 'C:\TestFolder\TestFile1.txt'
        Contents = 'My first Configuration'
        Force = $true
    }
  }
}

AddFile -OutputPath .\MOF -ComputerName 'W16TGT01', 'W16DSC02' 