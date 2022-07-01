function global:Format-XmlDocument {
     param
     (
         [string]$Path = "$PWD\fancy.xml"
     )

    $settings = New-Object System.Xml.XmlReaderSettings  
    $doc = (Resolve-Path -Path $Path).ProviderPath
    $reader = [System.Xml.XmlReader]::Create($doc, $settings)
    $indent=0
    function indent {
        param
        (
            [Object]$s
        )
        '  '*$indent+$s 
    }   
  
    while ($reader.Read())
    {
        if ($reader.NodeType -eq [Xml.XmlNodeType]::Element) 
        {
            $close = $(if ($reader.IsEmptyElement) { '/>' } else { '>' })
            if ($reader.HasAttributes)          
            {
                $s = indent "<$($reader.Name) "
                [void] $reader.MoveToFirstAttribute()      
                do                                              
                {                                               
                    $s += "$($reader.Name) = `"$($reader.Value)`" " 
                }                                                 
                while ($reader.MoveToNextAttribute())        
                "$s$close"
            }
            else
            {
                indent "<$($reader.Name)$close"
            }
            if ($close -ne '/>') {$indent++} 
        }
        elseif ($reader.NodeType -eq [Xml.XmlNodeType]::EndElement )
        {
            $indent--
            indent "</$($reader.Name)>"               
        }
        elseif ($reader.NodeType -eq [Xml.XmlNodeType]::Text)
        {
            indent $reader.Value 
        }
    }
    $reader.close()            
}