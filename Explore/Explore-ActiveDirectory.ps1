// Load the Active Directory module to get access to new cmdlets
// Part of RSAT tools

Import-Module ActiveDirectory

Get-ADForest

Get-ADDomain
Get-ADDomainController

Get-ADRootDSE


[System.Security.Principal.WindowsIdentity]::GetCurrent().Groups |
Format-Table -AutoSize

(Get-ADUser -Identity crhodes -Properties MemberOf | Select-Object MemberOf).MemberOf
(Get-ADUser -Identity vliyanap -Properties MemberOf | Select-Object MemberOf).MemberOf
(Get-ADUser -Identity hekim -Properties MemberOf | Select-Object MemberOf).MemberOf

Get-ADUser -Identity crhodes


Get-ADUser -Identity crhodes | Get-Member
// Curiously Get-Member does not show manager property
Get-ADUser -Identity crhodes -Properties manager
Get-ADUser -Identity crhodes | Get-Member -Force


Get-ADUser (Get-ADUser -Identity crhodes -Properties manager).manager

(Get-ADUser (Get-ADUser -Identity crhodes -Properties manager).manager).samaccountname


Get-ADComputer
Get-ADPrincipalGroupMembership -Identity crhodes

Get-ADPrincipalGroupMembership -Identity crhodes |
    Sort-Object | Select-Object name

Get-ADPrincipalGroupMembership
Get-ADGroupMember Administrators
Get-ADGroupMember Administrators -Recursive | format-table name, objectclass -AutoSize
Get-ADGroupMember "Life IT - Environment Support"
Get-ADUser -Filter 'Name -like "*vipula*"'
Get-ADUser -Filter 'Name -like "*nilesh*"'

Get-ADGroupMember "FAHQ-GL-TFS-Middleware_BA"

# Get AD Group stuff

Get-ADGroup Administrators | 
    Sort-Object Name | 
    Select-Object Name, SamAccountName, GroupCategory, GroupScope, @{n="Count"; e={(Get-ADGroupMember $_.Name).Count }} 

Get-ADGroup "FAHQ-DL-IT Maturity Journey-RO" | 
    Sort-Object Name | 
    Select-Object Name, SamAccountName, GroupCategory, GroupScope, @{n="Count"; e={(Get-ADGroupMember $_.Name).Count }} 

Get-ADGroup FAHQ-GL-TFS-Middleware_BA | 
    Sort-Object Name | 
    Select-Object Name, SamAccountName, GroupCategory, GroupScope, @{n="Count"; e={(Get-ADGroupMember $_.Name).Count }} 

Get-ADGroup -Filter * | 
    Sort-Object Name | 
    Select-Object Name, SamAccountName, GroupCategory, GroupScope, @{n="Count"; e={(Get-ADGroupMember $_.SamAccountName).Count }} | 
    Export-csv -Path C:\temp\ADGroups-LIFE-PACIFICLIFE.csv

Get-ADGroupMember Administrators 

Get-ADGroupMember Administrators | Get-Member
Get-ADGroupMember Administrators -Server devlifeint.devpl01.net
Get-ADOrganizationalUnit -Filter 'Name -like "*"' | format-table Name, DistinguishedName -AutoSize
Get-ADOrganizationalUnit -Filter 'Name -like "Domain Controllers"'
Get-ADOrganizationalUnit -Filter 'Name -like "Domain Controllers"' | Select-Object DistinguishedName
(Get-ADOrganizationalUnit -Filter 'Name -like "Domain Controllers"').DistinguishedName
Get-ADOrganizationalUnit -Filter 'Name -like "Domain Controllers"' | format-table Name, DistinguishedName -AutoSize
Get-ADDomainController
Get-ADDomainController -Discover -Service ADWS

Get-ADObject -Filter 'Name -like "*"' `
    -SearchBase (Get-ADOrganizationalUnit -Filter 'Name -like "Domain Controllers"').DistinguishedName |
    format-table DistinguishedName, ObjectClass -AutoSize


Get-ADObject -Filter 'Name -like "A097921NYP"' | Format-List -Property *

Get-ADGroup -filter 'Name -like "FACA-DL-IT-SOA"' | 
    Get-ADGroupMember | 
    Format-Table -Property name, SamAccountName

Get-ADGroup -filter 'Name -like "FAHQ-DL-IT Maturity Journey-RO"' | 
    Get-ADGroupMember | Sort-Object Name |
    Format-Table -Property name, SamAccountName > "FAHQ-DL-IT Maturity Journey-RO.txt"

$adGroupName = "FACA-DL-IT-SOA"

Get-ADGroup -filter 'Name -like $adGroupName' | 
    Get-ADGroupMember | 
    Format-Table -Property name, SamAccountName

"FACA-DL-IT-SOA", "FAHQ-DL-Middleware Services", "FAHQ-DL-Middleware Services Admin", "FAHQ-DL-Middleware Group", "FAHQ-GU-MWMSupport", "FAHQ-GU-MWMDevelopment", "FAHQ-GU-MWMAdmins" |
ForEach-Object {
    $_
    Get-ADGroup -filter 'Name -like $_' | 
        Get-ADGroupMember | 
        Format-Table -Property name, SamAccountName
}

"A", "B", "C" | ForEach-Object { $_}

Get-ADGroup -filter 'Name -like "FAHQ-DL-Middleware Group"' | 
    Get-ADGroupMember | 
    Format-Table -Property name, SamAccountName

Get-ADGroup -filter 'Name -like "FAHQ-DL-Middleware Services"' | 
    Get-ADGroupMember | 
    Format-Table -Property name, SamAccountName

Get-ADGroup -filter 'Name -like "FAHQ-DL-Middleware Services Admin"' | 
    Get-ADGroupMember | 
    Format-Table -Property name, SamAccountName

Get-ADComputer -Filter 'Name -like "A097921NYP"' | get-member
Get-ADComputer -Filter 'Name -like "A097921NYP"' -Properties * | get-member

Get-ADObject -Filter 'Name -like "*" -and ObjectClass -eq "computer"' `
    -SearchBase (Get-ADOrganizationalUnit -Filter 'Name -like "Domain Controllers"').DistinguishedName |
    format-table Name, DistinguishedName, ObjectClass -AutoSize

Get-ADOrganizationalUnit -Filter 'Name -like "*"' | 
    Foreach-Object `
    { 
        Write-Output "OU: $_.Name" ; `
        Get-ADObject -Filter 'Name -like "*" -and ObjectClass -eq "computer"' ` -SearchBase $_.DistinguishedName -Properties * |
        Sort-Object -Property Name | 
        format-table Name, Description -AutoSize
    } > C:\Temp\AllComputers.txt

Get-ADOrganizationalUnit -Filter 'Name -like "*"' | 
    Foreach-Object `
    { 
        Write-Output "OU: $_.Name" ; `
        Get-ADObject -Filter 'Name -like "*" -and ObjectClass -eq "computer"' ` -SearchBase $_.DistinguishedName -Properties * |
        Sort-Object -Property Name | 
        Format-table Name, Created, DNSHostName, OperatingSystem, Description -AutoSize
    } > C:\temp\AllComputers1.txt

Get-ADOrganizationalUnit -Filter 'Name -like "*"' | 
    Foreach-Object `
    { 
        Write-Output "OU: $_.Name" ; `
        Get-ADObject -Filter 'Name -like "*" -and ObjectClass -eq "computer"' ` -SearchBase $_.DistinguishedName -Properties * |
        Sort-Object -Property Name | 
        Export-Csv Name, Created, DNSHostName, OperatingSystem, Description -AutoSize
    } > C:\temp\AllComputers1.txt

Get-ADOrganizationalUnit -Filter 'Name -like "*"' | 
    Foreach-Object `
    { 
        Write-Output $_.Name ; `
        Get-ADObject -Filter 'Name -like "*" -and ObjectClass -eq "computer"' ` -SearchBase $_.DistinguishedName -Properties * |
        Sort-Object -Property Name | 
        Select-Object Name, Created, DNSHostName, OperatingSystem, Description | 
        Export-Csv -Append -Path C:\temp\foo.csv
    } 

Get-ADOrganizationalUnit -Filter 'Name -like "*"' | 
    Foreach-Object `
    { 
        Write-Output ($_.DistinguishedName).Replace(",", "-") ; `
        Get-ADObject -Filter 'Name -like "*" -and ObjectClass -eq "computer"' ` -SearchBase $_.DistinguishedName -Properties * |
        Sort-Object -Property Name | 
        Foreach-Object `
        {
            ",{0},{1},{2},{3},{4}" -f $_.Name, $_.DNSHostName, $_.OperatingSystem, $_.Description, $_.Created
        }
    } > "F:\temp\Environment Services\AllPacificMutualComputers.csv"

Get-ADComputer -Filter * -Properties Name, DistinguishedName, DNSHostName, OperatingSystem, Description, Created |
    Sort-Object -Property Name |
    Foreach-Object `
    {
        ",{0},{1},{2},{3},{4},{5}" -f $_.Name, $_.DNSHostName, $_.OperatingSystem, $_.Description, $_.Created, $_.DistinguishedName
    }

Get-ADComputer -Filter * -Properties Name, DistinguishedName, DNSHostName, OperatingSystem, Description, Created |
    Sort-Object -Property Name |
    Foreach-Object `
    {
        ",{0},{1},{2},{3},{4},{5}" -f $_.Name, $_.DNSHostName, $_.OperatingSystem, $_.Description, $_.Created, $_.DistinguishedName
    }

Get-ADComputer -Filter { OperatingSystem -NotLike '*Windows Server*' } `
    -Properties Name, DistinguishedName, DNSHostName, OperatingSystem, Description, Created |
    Sort-Object -Property Name |
    Foreach-Object `
    {
        ",{0},{1},{2},{3},{4},{5}" -f $_.Name, $_.DNSHostName, $_.OperatingSystem, $_.Description, $_.Created, $_.DistinguishedName
    }

Get-ADComputer -Filter { OperatingSystem -Like '*Windows Server 2003*' } `
    -Properties Name, DistinguishedName, DNSHostName, OperatingSystem, Description, Created |
    Sort-Object -Property Name |
    Foreach-Object `
    {
        ",{0},{1},{2},{3},{4},{5}" -f $_.ou, $_.Name, $_.DNSHostName, $_.OperatingSystem, ($_.DistinguishedName.substring($_.DistinguishedName.indexof(",")+1))
    } 

Get-ADComputer -Filter { OperatingSystem -Like '*Windows Server 2003*' }
(Get-ADComputer -Filter { OperatingSystem -Like '*Windows Server 2003*' }).Count

Get-ADComputer -Filter { OperatingSystem -Like '*Windows Server 2003*' } `
    -Properties Description `
    -ResultSetSize 5 | 
    Format-list Name, Description

Get-ADComputer -Filter { OperatingSystem -Like '*Windows Server 2003*' } `
    -Properties Description `
    -ResultSetSize 5 | 
    Select-Object Name, Description, DistinguishedName, @{Name="OU"; Expression={$_.DistinguishedName.substring($_.DistinguishedName.indexof(",")+1)}} |
    Format-list #Name, Description, DistinguishedName, OU

Get-ADComputer -Filter { OperatingSystem -Like '*Windows Server 2003*' } `
    -Properties Description `
    -ResultSetSize 5 | 
    Select-Object Name, Description, DistinguishedName, `
        @{Name="OU"; Expression={$_.DistinguishedName.substring($_.DistinguishedName.indexof(",")+1)}} |
    Group-Object OU |
    Format-list Name, Description, DistinguishedName, OU

Get-ADComputer -Filter { OperatingSystem -Like '*Windows Server 2003*' } `
    -Properties Description `
    -ResultSetSize 5 | 
    Select-Object Name, Description, DistinguishedName, `
        @{Name="OU"; Expression={$_.DistinguishedName.substring($_.DistinguishedName.indexof(",")+1)}} |
    Format-list Name, Description, DistinguishedName -GroupBy OU 

Get-ADComputer -Filter { OperatingSystem -Like '*Windows Server 2003*' } `
    -Properties Description, OperatingSystem `
    -ResultSetSize 5 | 
    Select-Object Name, OperatingSystem, Description, DistinguishedName, `
        @{Name="OU"; Expression={$_.DistinguishedName.substring($_.DistinguishedName.indexof(",")+1).Replace(",", " ")}} |
    Format-Table Name, OperatingSystem, Description -GroupBy OU 

Get-ADComputer -Filter { OperatingSystem -Like '*Windows Server 2003*' } `
    -Properties Description, OperatingSystem `
    -ResultSetSize 5 | 
    Select-Object Name, OperatingSystem, Description, DistinguishedName, `
        @{Name="OU"; Expression={$_.DistinguishedName.substring($_.DistinguishedName.indexof(",")+1).Replace(",", " ")}} |
    Sort-Object -Property Name |
    Format-Table Name, OperatingSystem, Description -GroupBy OU

Get-ADComputer -Filter { OperatingSystem -Like '*Server*' } `
    -Properties Description, OperatingSystem, OperatingSystemServicePack ` | 
    Select-Object Name, OperatingSystem, OperatingSystemServicePack, Description, DistinguishedName, `
        @{Name="OU"; Expression={$_.DistinguishedName.substring($_.DistinguishedName.indexof(",")+1).Replace(",", " ")}} |
    Sort-Object -Property OU, Name |
    Format-Table Name, OperatingSystem, OperatingSystemServicePack, Description -AutoSize -GroupBy OU |
    Out-String -Width 120 `
    > "F:\temp\Environment Services\All-PacificMutualComputers.txt"
