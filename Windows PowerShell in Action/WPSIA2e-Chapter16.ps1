############################################################
#
# Windows PowerShell in Action Chapter 16
# 
# Working with files, text, and XML
#
# 16.1 PowerShell and paths
#
# 16.2 File processing
#
# 16.3 Processing unstructured text
#
# 16.4 XML structured text processing
#
############################################################

# 16.1 PowerShell and paths

# 16.2 File processing

function Get-HexDump ($path = $(throw "path must be specified"), $width = 10, $total = -1)
{
    $OFS = ""
    Get-Content -Encoding byte $path -ReadCount $width -TotalCount $total |
        %{ $record = $_

        if (($record -eq 0).Count -ne $width)
        {
            $hex = $record | %{ " " + ("{0:x}" -f $_).PadLeft(2,"0")}
            $char = $record | %{ 
                if ([char]::IsLetterOrDigit($_))
                {
                    [char]$_
                }
                else
                {
                    "."
                }
            }

            "$hex $char"

        }
    }
}

Get-HexDump "$env:windir/notepad.exe" -w 12 -t 100

# 16.3 Processing unstructured text

# 16.4 XML Structured Text Processing

# Using XML as objects

$d = [xml] "<top><a>one</a><b>two</b><c>3</c></top>"
$d
$d.top
$d.top.a
$d.top.a = "ONE"
$d.top.a
$d.top.c

# Can only use strings

$d.top.c = 4
$d.top.c = "4"
$d.top.c

# Adding elements

$el = $d.CreateElement("d")
$el

$el.set_innerText("Hello")
$el
$d.top
$ne = $d.CreateElement("e")
$ne.InnerText = "World"
$d.top.AppendChild($el)
$d.top.AppendChild($ne)
[string]$d
$d.ToString()
$d.Save("C:\temp\new.xml")
type c:\temp\new.xml
$attr = $d.CreateAttribute("BuiltBy")
$attr.Value = "Windows PowerShell"
$d.DocumentElement.SetAttributeNode($attr)
$d.top
$d.Save("C:\temp\new.xml")
type c:\temp\new.xml

# Loading and saving XML files

$nd1 = [xml] (Get-Content -Read 10kb C:\temp\new.xml)
#or - this doesn't seem to work
$nd2 = ([xml]"<root></root>").Load("C:\temp\new.xml")

@'
<top BuiltBy = "Windows PowerShell">
    <a pronounced="eh">
        one
    </a>
    <b pronounced="bee">
        two
    </b>
    <c one="1" two="2" three="3">
        <one>
            1
        </one>
        <two>
            2
        </two>
        <three>
            3
        </three>
    </c>
    <d>
        Hello there world
    </d>
</top>
'@ > C:\temp\fancy.xml

function global:Format-XmlDocument ($doc="$PWD\fancy.xml")
{
    $settings = New-Object System.Xml.XmlReaderSettings
    $doc = (Resolve-Path $doc).ProviderPath
    $reader = [System.Xml.XmlReader]::create($doc, $settings)
    $indent=0
    
    function indent ($s) { "  "*$indent+$s }

    while ($reader.Read())
    {
        if ($reader.NodeType -eq [Xml.XmlNodeType]::Element)
        {
            $close = $(if ($reader.IsEmptyElement) { "/>" } else { ">" } )
            
            if ($reader.HasAttributes)
            {
                $s = indent "<$($reader.Name) "
                [void] $reader.MoveToFirstAttribute()

                do
                {
                    $s += "$($reader.Name)=`"$($reader.Value)`" "
                } 
                while ($reader.MoveToNextAttribute())

                "$s$close"
            }
            else
            {
                indent "<$($reader.name)$close"
            }
            
            if ($close -ne '/>') { $indent++ }   
        }
        elseif ($reader.NodeType -eq [Xml.XmlNodeType]::EndElement)
        {
            $indent--
            indent "</$($reader.Name)>"
        }
        elseif ($reader.NodeType -eq [Xml.XmlNodeType]::Text)
        {
            indent $reader.Value
        }
    }

    $reader.Close()
}

$inventory = @"
   <bookstore>
     <book genre="Autobiography">
       <title>The Autobiography of Benjamin Franklin</title>
       <author>
         <first-name>Benjamin</first-name>
         <last-name>Franklin</last-name>
       </author>
       <price>8.99</price>
       <stock>3</stock>
     </book>
     <book genre="Novel">
       <title>Moby Dick</title>
       <author>
         <first-name>Herman</first-name>
         <last-name>Melville</last-name>
       </author>
       <price>11.99</price>
       <stock>10</stock>
     </book>
     <book genre="Philosophy">
       <title>Discourse on Method</title>
       <author>
         <first-name>Rene</first-name>
         <last-name>Descartes</last-name>
       </author>
       <price>9.99</price>
       <stock>1</stock>
     </book>
     <book genre="Computers">
       <title>Windows PowerShell in Action</title>
       <author>
         <first-name>Bruce</first-name>
         <last-name>Payette</last-name>
       </author>
       <price>39.99</price>
       <stock>5</stock>
     </book>
   </bookstore>
"@

# The Select-Xml commandlet

Select-Xml -Content $inventory -XPath /bookstore

# To extract the node, reference as a property

(Select-Xml -Content $inventory -XPath /bookstore).Node

# Get book nodes

Select-Xml -Content $inventory -XPath /bookstore/book

# Get elements for one book

(Select-Xml -Content $inventory -XPath /bookstore/book)[0].Node

# Get elements for all books

Select-Xml -Content $inventory -XPath /bookstore/book |
    %{$_.Node}

# If just want title can expand XPath or details of node

Select-Xml -Content $inventory -XPath /bookstore/book/title |
    %{$_.Node}

Select-Xml -Content $inventory -XPath /bookstore/book |
    %{$_.Node.Title}

# Can further refine what you need back.  Just get Genre and Title

Select-Xml -Content $inventory -XPath /bookstore/book |
    %{"G:{0,20} T:{1}" -f $_.Node.Genre, $_.Node.Title} 

# Define filter to make typing easier

filter node {$_.Node}
filter title {$_.Node.Title}

Select-Xml -Content $inventory -XPath /bookstore/book | node
Select-Xml -Content $inventory -XPath /bookstore/book | title

Select-Xml -Content $inventory -XPath /bookstore/book | node | %{$_.Title}

# Filter using Where-Object

Select-Xml -Content $inventory -XPath /bookstore/book |
    node | Where-Object { [double] ($_.Price) -lt 10 }

# Filter using Predicate Expressions

Select-Xml -Content $inventory -XPath '/bookstore/book[price < 10]' |
    node 

# Filter using Predicate Expressions

Select-Xml -Content $inventory -XPath '/bookstore/book/title[../price < 10]' |
    node 

# Select attributes using @<attribute>

# Get all the values of the Genre attribute

Select-Xml -Content $inventory -XPath '//@genre' |
    node 

# Can also use attribures in Predicate Expressions

Select-Xml -Content $inventory -XPath '//book[@genre = "Novel"]' |
    node 


# XPath and Where-Object behave differently.
# NB. The results when the case of things changes.

# Genre not a attribute. genre is.

Select-Xml -Content $inventory -XPath '//book[@Genre = "Novel"]' |
    node 

# novel not the value.  Novel is.

Select-Xml -Content $inventory -XPath '//book[@genre = "novel"]' |
    node 

# Where-Object is case insensitive.
# NB. Genre and novel

Select-Xml -Content $inventory -XPath //book |
    node | Where-Object { $_.Genre -eq 'novel' }

# Perform some calculations.
# Go learn about Measure-Object

Select-Xml -Content $inventory -XPath //book |
    node | 
    %{ [double] $_.Price * $_.Stock } |
    Measure-Object -Sum |
    %{ $_.Sum }

# Using XLinq

# Add assemblies needed by XLinq

Add-Type -AssemblyName System.Core
Add-Type -AssemblyName System.Xml.Linq

$xldoc1 = [System.Xml.Linq.XDocument] $inventory
$xldoc1
$xldoc1 | gm

$xldoc2 = [System.Xml.Linq.XDocument]::Load("C:\temp\fancy.xml")
$xldoc2
$xldoc2 | gm

$xldoc1.Descendants("book").Elements("title").Value

$xldoc2.Descendants("a").Value
