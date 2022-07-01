workflow demo-scope { 
    # This is a workflow top-level variable 
    $a = 22 
    "Initial value of A is: $a" 

    # Access $a from Inlinescript (bringing a workflow variable to the PowerShell session) using $using 
    inlinescript {"PowerShell variable A is: $a"} 
    inlinescript {"Workflow variable A is: $using:a"} 
    
    ## changing a variable value
    $a = InlineScript {$b = $Using:a+5; $b}
    "Workflow variable A after InlineScript change is: $a"

    parallel { 
        sequence { 
            # Reading a top-level variable (no $workflow: needed) 
            "Value of A inside parallel is: $a" 
    
            # Updating a top-level variable with $workflow:<variable name> 
            $workflow:a = 3
        } 
    } 
    "Updated value of A is: $a" 
}
demo-scope 