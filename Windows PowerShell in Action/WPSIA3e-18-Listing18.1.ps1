Configuration AddFile {
  Node W16TGT01 { 
    File TestFile {
        Ensure = 'Present'
        Type = 'File'
        DestinationPath = 'C:\TestFolder\TestFile1.txt'
        Contents = 'My first Configuration'
        Force = $true
    }
  }
}
AddFile -OutputPath .\MOF