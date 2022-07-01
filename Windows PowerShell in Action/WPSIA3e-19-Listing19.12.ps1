enum FWprofile { 
    Domain
    Private
    Public
}

enum Ensure { 
    Absent
    Present
}

[DscResource()]  
class FireWallStatus {

    [DscProperty(Key)]
    [FWprofile]$profileName

    [DscProperty(Mandatory)]
    [Ensure]$ensure

    [DscProperty(NotConfigurable)]
    [bool]$enabled

    [FirewallStatus]Get() {
        $fwp = Get-NetFirewallProfile -Name $this.profileName
        $test = [Hashtable]::new()
        $test.Add('ProfileName',$fwp.Name)
        $test.Add('Ensure', $this.Ensure)

        if ($fwp.Enabled) {$test.Add('Enabled', $true)}
        else {$test.Add('Enabled',$false)}
        
        return $test
    }

    [void]Set() { 
        $fwp = Get-NetFirewallProfile -Name $this.profileName
        if ($this.ensure -eq [Ensure]::Present) {
           if (-not $fwp.Enabled) {
              Set-NetFirewallProfile -Name $this.profileName -Enabled True   
           } 
        }
        else {
           if ($fwp.Enabled) {
              Set-NetFirewallProfile -Name $this.profileName -Enabled False   
           } 
        }
    }

    [bool]Test() { 
        $fwp = Get-NetFirewallProfile -Name $this.profileName
        if ($this.ensure -eq [Ensure]::Present) {
           if ($fwp.Enabled) {
             return $true
           }
           else {
             return $false
           } 
        }
        else {
           if ($fwp.Enabled) {
             return $true
           }
           else {
             return $false
           } 
        }
    }
}
