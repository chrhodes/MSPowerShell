Configuration fwstatus {
    param (
        [Parameter(Mandatory=$true)]
        [string[]]$computername,

        [Parameter(Mandatory=$true)]
        [string]$profilename,

        [Parameter(Mandatory=$true)]
        [bool]$enabled
    )

    Import-DscResource -ModuleName firewallstatus 

    if ($enabled) {$ens = 'Present'}
    else {$ens = 'Absent'}


    Node $computername {
        FirewallStatus fwstoggle {
            ProfileName = $profilename 
            Ensure = $ens
        }
    }
}

fwstatus -computername W16TGT01 -profilename Domain -enabled $true -OutputPath C:\Scripts\MOF