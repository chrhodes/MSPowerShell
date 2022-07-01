Get-PSSnapin
Get-PSSnapin -Registered

<#
Should see this on a SharePoint Server

    Name        : Microsoft.SharePoint.PowerShell
    PSVersion   : 1.0
    Description : Register all administration Cmdlets for Microsoft SharePoint Server
#>

Add-PSSnapin Microsoft.SharePoint.PowerShell

$web = Get-SPWeb http://vncsharepoint

$web.Title
$web.Groups
$ownerGroup = $web.SiteGroups["VNCWiki Owners"]
$ownerGroup.Users


$user1 = $web.Site.RootWeb.EnsureUser("vnc\vschanz")
$user1

# This won't work unless the user running PowerShell has Site collection privileges at the time the shell starts
# may have to do with when $web is loaded.  I added vnc\administrator to Site Collection Administrators and this worked.

$ownerGroup.AddUser($user1)

# Above Didn't work.  
#$ownerGroup.AllowMembersEditMembership

#$ownerGroup.AllowMembersEditMembership = $true
#$ownerGroup.Update()

# Now have more uses in Group

$ownerGroup.Users