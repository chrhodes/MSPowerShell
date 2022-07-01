Get-PSSnapin
Get-PSSnapin -Registered
Add-PSSnapin Microsoft.SharePoint.PowerShell
$web = Get-SPWeb http://vncsharepoint
$web | Get-Member
$web
$web.Title, $web.Theme

foreach ($r in $web.Roles)
{
    $r.Name
}

foreach ($u in $web.SiteUsers)
{
    $u.Name
}

foreach ($u in $web.Users)
{
    $u.Name
}

foreach ($sg in $web.SiteGroups)
{
    $sg.Name
}

$ownersGroup = $web.SiteGroups["$web Owners"]
$ownersGroup.Count

$ownersGroup | Select-Object *

foreach ($u in $ownersGroup.Users)
{
    $u.Name, $u.DisplayName, $u.UserLogin, $u.IsDomainGroup
}

function DisplayUsers($SharePointGroup)
{
    foreach ($u in $SharePointGroup.Users)
    {
        $u.Name, $u.DisplayName, $u.UserLogin, $u.IsDomainGroup
    }
}


DisplayUsers $ownersGroup

DisplayUsers $web.SiteGroups["$web Owners"]

DisplayUsers $web.SiteGroups["$web Members"]

function DisplayGroupMembers($SPWeb)
{
    "<<< Owners >>>"

    DisplayUsers $SPWeb.SiteGroups["$SPWeb Owners"]

    "<<< Members >>>"
    DisplayUsers $SPWeb.SiteGroups["$SPWeb Members"]
}

DisplayGroupMembers $web
