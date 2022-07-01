# Support Functions.

function Get-WebServiceUri($webApplication, $webServiceName)
{
    $webApplication + "/_vti_bin/" + $webServiceName + ".asmx"
}

function Get-WebServiceProxy($webServiceUri)
{
    $webService = New-WebServiceProxy -Uri $webServiceUri -UseDefaultCredential

    # Add something to test that service works and add error handling.
    return $webService
}

function Get-WebServiceMethods($webService)
{
    $webService | Get-Member -MemberType Method
}

$webApp = "http://vncsharepoint"



$webServicesList = 
    "Alerts"

$webServicesList = 
    "Alerts", "Authentication", "BusinessDataCatalog", "ContentAreaToolboxService", "Copy",
    "Diagnostics", "DiscoveryInternalService", "DspSts", "Dms", "ExcelService",
    "Forms", "FormsServiceProxy", "FormsServices", "Imaging", "Lists", "Meetings", "OfficialFile",
    "People", "Permissions", "ProfileImportExportService", "PublishedLinksService", "PublishingService", "PublishService",
    "Search", "SharedAccess", "SharePointEmailWs", "SiteData", "Sites", "SlideLibrary", "SocialDataService", "SpellCheck", "SpCrawl", "SpSearch",
    "TaxonomyClientService", "UserGroup", "UserProfileChangeService", "UserProfileService",
    "Versions", "Views", "WebPartPages", "Webs", "Workflow"

$webServicesList | 
    foreach-object { Get-WebServiceProxy (Get-WebServiceUri $webApp $_ ) } | 
    foreach-object { $_.ToString() ; Get-WebServiceMethods $_ ; $_.Dispose() } | 
    Format-List Name 2>&1 > "C:\temp\sp2013webservices.txt"
    #Format-List Name, Definition 2>&1 > "C:\temp\sp2013webservices.txt"
    #Format-Table -Wrap -AutoSize Name, Definition 2>&1 > "C:\temp\sp2013webservices.txt"


#region Stuff with Lists

$ListsWS = Get-WebServiceProxy (Get-WebServiceUri $webApp "Lists")

Get-WebServiceMethods $ListsWS

$lc = $ListWS.GetListCollection() 
$lc | Get-Member

$ListsWS.Dispose()


#endregion


#region Stuff with People

$PeopleWS = Get-WebServiceProxy (Get-WebServiceUri $webApp "People")

Get-WebServiceMethods $PeopleWS


$PeopleWS.Dispose()


#endregion


#region Stuff with Permissions

$PermissionsWS = Get-WebServiceProxy (Get-WebServiceUri $webApp "Permissions")

Get-WebServiceMethods $SitesWS


$SitesWS.Dispose()

#endregion


#region Stuff with Sites

$SitesWS = Get-WebServiceProxy (Get-WebServiceUri $webApp "Sites")

Get-WebServiceMethods $SitesWS


$SitesWS.Dispose()

#endregion


#region Stuff with UserGroup

$UserGroupWS = Get-WebServiceProxy (Get-WebServiceUri $webApp "UserGroup")

Get-WebServiceMethods $UserGroupWS


$UserGroupWS.Dispose()

#endregion


#region Stuff with Webs

function Display-SPWebInfo($spWeb)
{
    "Description:" + $spWeb.Description
    "FarmId:" + $spWeb.FarmId
    "Id:" + $spWeb.Id
    "Title:" + $spWeb.Title
    "Url:" + $spWeb.Url
}

$WebsWS = Get-WebServiceProxy (Get-WebServiceUri $webApp "Webs")

Get-WebServiceMethods $WebsWS

$webCol = $WebsWS.GetWebCollection() 
#$webCol.
($webCol).GetType()
$webSite = $WebsWS.GetWeb("http://vncsharepoint")

$webSite | get-member

Display-SPWebInfo $webSite

Get-SubSiteUri $webCol

$webCol | Foreach-Object {$_.BaseUri, $_.InnerText, $_.InnerXml, $_.LocalName, $_Name, $_.NamespaceURI, $_OuterXML, $_.Value}

function Get-SubSiteUri($webCol)
{
    $webCol | Foreach-Object { $_.InnerXml }
}

$WebsWS.Dispose()

#endregion

Function Get-SPList {
 
    <#
    .SYNOPSIS
         Uses SharePoint web services to pull down the contents of a SharePoint List
 
    .DESCRIPTION
         Get-SPList uses SharePoint web services to query for the data in a SharePoint list
 
    .PARAMETER SiteURL
        The URL of the SharePoint site where the list is located.
 
    .PARAMETER SPList
        The name of the SharePoint list.
 
    .NOTES
        Author: Chris Mischak
        LastEdit: 4/21/2013
        Version: 1.0.8
 
    .EXAMPLE
        C:\PS>Get-SPlist -SiteURL "https://www.SharePoint.com/sites/NameOfYourSite" -SPList "Name of Your List"
 
        Description
        -----------
        This command dumps the contents of a list to the screen.
 
    .EXAMPLE
        C:\PS>$listdata = Get-SPlist -SiteURL "https://www.SharePoint.com/sites/NameOfYourSite" -SPList "Name of Your List"
 
        Description
        -----------
        Slightly different way of executing the funtion. Dumps the contents to a variable named $listdata
    #>
 
    [CmdletBinding()]
    Param (
            [Parameter(Mandatory=$True,
            ValueFromPipeline=$True,
            ValueFromPipelineByPropertyName=$True,
            HelpMessage="Enter SharePoint Site URL")]
            [string]$SiteURL,
 
            [Parameter(Mandatory=$True,
            ValueFromPipelineByPropertyName=$True,
            HelpMessage="Enter SharePoint List Name")]
            [string]$SPList
    )
 
    BEGIN {}
    PROCESS {
        #Create the URI (used to connect to the SharePoint web service)
        $uri = $SiteURL+"/_vti_bin/Lists.asmx?wsdl"
 
        # Create xml query to retrieve list.
        $xmlDoc = new-object System.Xml.XmlDocument
        $query = $xmlDoc.CreateElement("Query")
        $viewFields = $xmlDoc.CreateElement("ViewFields")
        $queryOptions = $xmlDoc.CreateElement("QueryOptions")
        $query.set_InnerXml("FieldRef Name='Full Name'")
 
        $rowLimit = "5000"
 
        $list = $null
        $service = $null
 
        # Create the service
        try{
            $service = New-WebServiceProxy -Uri $uri -Namespace SpWs -UseDefaultCredential -ErrorAction Stop
        }
        catch{
            Write-Warning $_
        }
 
        #Use the service object to retrieve the list.
        if($service -ne $null){
            try{
                ($service.GetListItems($SPList, "", $query, $viewFields, $rowLimit, $queryOptions, "")).data.row
            }
            catch{
                Write-Warning $_
            }
        }
    }
    END {}
}

Get-SPList -SiteURL "http://vncsp2010" -SPList "Fruits"

