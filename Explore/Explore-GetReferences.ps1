$references=Get-ChildItem c:\temp\bin -rec | % {
    $loaded  = [reflection.assembly]::LoadFile($_.FullName)
    $name    =$loaded.ManifestModule
    $loaded.GetReferencedAssemblies() | % {
        $toAdd='' | select Who,FullName,Name,Version
        $toAdd.Who,$toAdd.FullName,$toAdd.Name,$toAdd.Version = `
            $loaded,$_.FullName,$_.Name,$_.Version
        $toAdd
    }
}

$references | 
    Group-Object FullName,Version | 
    Select-Object -expand Name | 
    Sort-Object


get-childitem C:\temp\bin | get-me


function Get-ReferencedAssemblies {
    param(
    [Parameter(
        Position=0,
        Mandatory=$true,
        ValueFromPipeline=$true,
        ValueFromPipelineByPropertyName=$true)
    ]
    [Alias('FullName')]
    [String[]]$FilePath
    )

    process {
        foreach($path in $FilePath)
        {
            $loaded  = [reflection.assembly]::LoadFile($_.FullName)
            $name    =$loaded.ManifestModule
            $loaded.GetReferencedAssemblies() | % {
                $toAdd='' | select Who,FullName,Name,Version
                $toAdd.Who,$toAdd.FullName,$toAdd.Name,$toAdd.Version = `
                    $loaded,$_.FullName,$_.Name,$_.Version
                $toAdd
            }        
        }
    }
}