$title = "Audit Tables"

Header $title

#Clone the structure of the DataSet from Tables.ps1
$AuditTables = $global:TablesResults.Clone()

#This function searches results from Tables.ps1 and add the row to $AuditTables
function AddRow{
    param (
        [Parameter(Mandatory=$true)][string]$TableName
    )

    #Search the tables list for $TableName
    $rows = $global:TablesResults.tables[0].Where({$_."Table Name" -Like $TableName})

    #Import $TableName's row(s)
    foreach($row in $rows){
        $AuditTables.tables[0].ImportRow($row)
    }
}

AddRow('AuditRecord')
AddRow('*EventAudit')
AddRow('*EventInfo')

#Create a temp DataView and sort
$DataView = New-Object System.Data.DataView($AuditTables.tables[0])
$DataView.Sort="Rows DESC"
$SortedDataTable = $DataView.ToTable()

#Clone the structure of the DataSet from Tables.ps1
# $results = $global:TablesResults.Clone()

#Copy $SortedDataTable into $results.tables[0]
$results = New-Object System.Data.DataSet
$results.Tables.Add($SortedDataTable)

.\ps1\00_TableToHtml.ps1 -tableID 0 -textOutput $true

$comments = 
"Report on table names matching: <ul><li>AuditRecord</li><li>*EventAudit</li><li>*EventInfo</li></ul>
This is a way to check if auditing needs to be purged"
Comments $comments

Footer
