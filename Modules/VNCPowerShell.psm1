#################################################
#
# VNCPowerShell.psm1
#
#################################################

####################
# Aliases
####################

new-alias -Name n++ -Value 'C:\Program Files\Notepad++\notepad++.exe'

####################
# Modules
####################

Import-Module posh-git

####################
# Functions
####################

function Write-Status($message, $color="White")
{
    $message | Write-Host -ForegroundColor $color;
}

function Log-Message()
{
    param
    (
        [string] $message,
        [string] $method,
        [string] $logLevel
    )
    
	# <TODO: Each case can be modified to do the appropriate type of console/PLLog logging.
    # TODO
    # Update to use VNCLog
    
    switch ($logLevel)
    {
        "Trace"
        { 
            if ($SCRIPT:Verbose) { Write-Status $message  "Yellow"}
            if ($SCRIPT:UsePLLog) { Call-PLLog -Trace   -message $message -class "Process-DLPFiles" -method $method }
            break
        }    
        
        "Info"
        { 
            # if ($SCRIPT:Verbose) { Write-Host $message }   
			Write-Status $message "Green"
            if ($SCRIPT:UsePLLog) { Call-PLLog -Info    -message $message -class "Process-DLPFiles" -method $method }
            break
        }
        
        "Warning"
        { 
            Write-Status $message  "Orange"
            if ($SCRIPT:UsePLLog) { Call-PLLog -Warning -message $message -class "Process-DLPFiles" -method $method }
            break
        }
		
        "Error"
        { 
            Write-Status $message  "Red"
            if ($SCRIPT:UsePLLog) { Call-PLLog -Error   -message $message -class "Process-DLPFiles" -method $method }
            break
        }
        
        "None"
        { 
            if ($SCRIPT:Verbose) { Write-Status $message }        
            break
        }
        
        default
        {
            Write-Status $message        
            if ($SCRIPT:UsePLLog) {  Call-PLLog -Error "Unexpected log level" + $logLevel -class "Process-DLPFiles" -method "LogMessage" }
            break
        }
    }
}

function LogMessage()
{
    param
    (
        [string] $message,
        [string] $method,
        [string] $logLevel
    )
	
	Log-Message $message, $method, $logLevel
}

function displayProfiles()
{   
    Write-Status "PowerShell Host Info"
    $Host

    $hostNames = @($profile | 
        Get-Member -MemberType Noteproperty | 
        Foreach-Object { $_.Name } )

    foreach ($h in $hostNames) { checkHostProfile $h}
}

function checkHostProfile([string] $hostName)
{
    Write-Status $hostName Cyan
    $PROFILE.$hostName

    $result = Test-Path $profile.$hostName

    if ($result -eq "true")
    {
        Write-Status "Exists" Green
    }
    else
    {
        Write-Status "Does Not Exist" Red
    }

    ""
}