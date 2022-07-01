# New-Snippet.ps1
# Generates this when invoked
# Put you code below and then run entire section
[scriptblock]$code = 
{
    [scriptblock]$code = 
    {#PutYourCodeHere
    }
 
    New-IseSnippet `
        -Text $code.ToString() `
        -CaretOffset $code.ToString().Length `
        -Force `
        -Title ‘SnippetTitle’ `
        -Description ‘SnippetDescription’
}
 
# Get snippets folder path
Join-Path (Split-Path -Parent $profile) "snippets" -Resolve

#Sample code to create "PSCredential" ISE code snippet

New-IseCustomSnippet -Title "PSCredential" -Description "Create new PSCredential object" -ScriptBlock {
$cred = New-Object Management.Automation.PsCredential("Administrator", (ConvertTo-SecureString "<#Stub#>" -AsPlainText -Force))

# Sample code to create "Stopwatch" ISE code snippet

New-IseCustomSnippet -Title "Stopwatch" -Description "Measure PowerShell code block execution times" -ScriptBlock {
$sw = [Diagnostics.Stopwatch]::StartNew()
foreach($i in 1..1000)
{
    #Stub
}
$elapsed = $sw.Elapsed
Write-Host ("Elapsed {0} [ms]" -f $elapsed.TotalMilliseconds)
}

function New-IseCustomSnippet
{
    param (
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory)]
        [string] $Title,
        [ValidateNotNullOrEmpty()]
        [string] $Description = "Description",
        [string] $Author = "",
        [Parameter(Mandatory)]
        [ScriptBlock] $ScriptBlock
    )
 
    $stubText = "<#Stub#>"
    $text = $ScriptBlock.ToString()
    $caretOffset = $text.IndexOf($stubText) #Find Stub text
 
    if ($caretOffset -gt 0){
        $text = $text.Remove($caretOffset, $stubText.Length) #Remove Stub text
    }
    else {
        $caretOffset = 0 #Reset caret position
    }
 
    $params = @{
        Title = $Title
        Description = $Description
        Author = $Author
        Text = $text
        CaretOffset = $caretOffset
    }
    New-IseSnippet @params -Force
}


New-IseSnippet -Title "Calculated Property" -Description "Syntax for a Calculated Property" -Text "@{N='Title';E={ }}" -CaretOffset 5 


$Snippet = @'
 Param
 (

[parameter(Mandatory=$true,ValueFromPipeline=$true)]
 [ValidateNotNullOrEmpty()]
 [String[]]$Parameter1,


 [parameter(Mandatory=$false,ValueFromPipeline=$false)]
 [ValidateNotNullOrEmpty()]
 [PSObject[]]$Parameter2
 )
'@

New-IseSnippet -Title "Param Block" -Description "Syntax for a Param Block" -Text $Snippet

# Hide ISE default snippets
$psIse.Options.ShowDefaultSnippets = $false

# Ctrl-F1 - invoke Show-Command on entry under cursor
New-IseSnippet

# Import snippets from folder
					
Import-IseSnippet -Path 'C:\Temp'