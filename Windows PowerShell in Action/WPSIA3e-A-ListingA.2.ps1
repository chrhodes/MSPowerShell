Configuration LxDSCConfig
{
 param ([string]$node)

  Import-DSCResource -Module nx

  Node $node
  {     
    nxFile myTestFile
    {
      Ensure = "Present"  
      Type = "File"
      DestinationPath = "/tmp/dsctest"    
      Contents="This is our DSC on Linux Test!"
    }
  }
}

LxDSCConfig -node Lin01 -OutputPath .\MOF