function Test-Spelling {
    $wshell = New-Object -ComObject WScript.Shell 
    $word = New-Object -ComObject Word.Application
    $word.Visible = $false 
    $doc = $word.Documents.Add() 
    $word.Selection.Paste()                                            
    
    if ($word.ActiveDocument.SpellingErrors.Count -gt 0)         
    {
        $word.ActiveDocument.CheckSpelling()                     
        $word.Visible = $false                                   
        $word.Selection.WholeStory()                             
        $word.Selection.Copy()                                   
        $wshell.PopUp( 'The spell check is complete, ' +         
        'the clipboard holds the corrected text.' )
    }
    else
    {
        [void] $wshell.Popup('No Spelling Errors were detected.') 
    }
    
    $x = [ref] 0                                                  
    $word.ActiveDocument.Close($x)
    $word.Quit()
}