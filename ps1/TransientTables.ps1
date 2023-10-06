$title = "Transient Tables"

Header $title

#Clone the structure of the DataSet from Tables.ps1
$TransientTables = $global:TablesResults.Clone()

#This function searches results from Tables.ps1 and add the row to $TransientTables
function AddRow{
    param (
        [Parameter(Mandatory=$true)][string]$TableName
    )

    #Search the tables list for $TableName
    $rows = $global:TablesResults.tables[0].Where({$_."Table Name" -eq $TableName})

    #Import $TableName's row(s)
    foreach($row in $rows){
        $TransientTables.tables[0].ImportRow($row)
    }
}

AddRow('CacheStatistics')
AddRow('CollectorCache')
AddRow('ExtendedPageResults')
AddRow('JmxNotifications')
AddRow('Log4JavascriptEvents')
AddRow('MethodContexts')
AddRow('MethodContextStats')
AddRow('MethodServerInfo')
AddRow('MiscLogEvents')
AddRow('MSHealthStats')
AddRow('PageResults')
AddRow('QueueEntry')
AddRow('RawMethodContextStats')
AddRow('RawServletRequestStats')
AddRow('RecentUpdate')
AddRow('RemoteCacheServerCalls')
AddRow('RequestHistograms')
AddRow('RmiHistograms')
AddRow('RmiPerfData')
AddRow('SampledMethodContexts')
AddRow('SampledServletRequests')
AddRow('ServerManagerInfo')
AddRow('ServletRequests')
AddRow('ServletRequestStats')
AddRow('ServletSessionStats')
AddRow('SMHealthStats')
AddRow('TopSQLStats')
AddRow('UserAgentInfo')

#Create a temp DataView and sort
$DataView = New-Object System.Data.DataView($TransientTables.tables[0])
$DataView.Sort="Rows DESC"
$SortedDataTable = $DataView.ToTable()

#Clone the structure of the DataSet from Tables.ps1
# $results = $global:TablesResults.Clone()

#Copy $SortedDataTable into $results.tables[0]
$results = New-Object System.Data.DataSet
$results.Tables.Add($SortedDataTable)

.\ps1\00_TableToHtml.ps1 -tableID 0 -textOutput $true

$comments = 
"Tables that hold transient data and may grow to certain size causing performance problems."
Comments $comments

Footer
