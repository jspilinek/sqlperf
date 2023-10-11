$title = "DupeIndexes"

Header $title

#Create a $results DataSet to use with 00_TableToHtml.ps1
$results = New-Object System.Data.DataSet

#Create two DataTables
$resultsTab = New-Object System.Data.DataTable
$resultsTabB = New-Object System.Data.DataTable

#Define columns
$col1 = New-Object System.Data.DataColumn("Table Name")
$col2 = New-Object System.Data.DataColumn("Index Name")
$col3 = New-Object System.Data.DataColumn("Indexed Column Names")
$col4 = New-Object System.Data.DataColumn("Included Column Names")
$col5 = New-Object System.Data.DataColumn("Index Type")
$col6 = New-Object System.Data.DataColumn("Indexed Column Names without idA2A2")
$col7 = New-Object System.Data.DataColumn("Included Column Names without idA2A2")

$col1b = New-Object System.Data.DataColumn("Table Name")
$col2b = New-Object System.Data.DataColumn("Index Name")
$col3b = New-Object System.Data.DataColumn("Indexed Column Names")
$col4b = New-Object System.Data.DataColumn("Included Column Names")
$col5b = New-Object System.Data.DataColumn("Index Type")
$col6b = New-Object System.Data.DataColumn("Indexed Column Names without idA2A2")
$col7b = New-Object System.Data.DataColumn("Included Column Names without idA2A2")

#Add Columns to DataTable
$resultsTab.Columns.Add($col1)
$resultsTab.Columns.Add($col2)
$resultsTab.Columns.Add($col3)
$resultsTab.Columns.Add($col4)
$resultsTab.Columns.Add($col5)
$resultsTab.Columns.Add($col6)
$resultsTab.Columns.Add($col7)

$resultsTabB.Columns.Add($col1b)
$resultsTabB.Columns.Add($col2b)
$resultsTabB.Columns.Add($col3b)
$resultsTabB.Columns.Add($col4b)
$resultsTabB.Columns.Add($col5b)
$resultsTabB.Columns.Add($col6b)
$resultsTabB.Columns.Add($col7b)

#Add DataTables to DataSet
$results.tables.Add($resultsTab)
$results.tables.Add($resultsTabB)

#$currentTable is used to track the current table being reviewed from Indexes.html
$currentTable = $results.Clone()

#Adds a row to $currentTable
function importRowIntoCurrentTable{
    param (
        [Parameter(Mandatory=$true)][System.Data.DataRow]$row
    )
    $newRow = $currentTable.tables[0].NewRow()
    $newRow["Table Name"] = $row["Table Name"]
    $newRow["Index Name"] = $row["Index Name"]
    $newRow["Indexed Column Names"] = $row["Column Name"]
    $newRow["Included Column Names"] = ""
    $newRow["Index Type"] = $row["Index Type"]

    if($row["Column Name"] -eq "idA2A2"){
        $newRow["Indexed Column Names without idA2A2"] = ""
    }else{
        $newRow["Indexed Column Names without idA2A2"] = $row["Column Name"]
    }
    $newRow["Included Column Names without idA2A2"] = ""

    $currentTable.tables[0].Rows.Add($newRow)
}

#Either adds a new row or updates an existing row in $currentTable
function indexRow{
    if ($ColmID -eq 1){
        importRowIntoCurrentTable($row)
    }else{
        foreach($r in $currentTable.tables[0]){
            $rTableName = $r["Table Name"]
            $rIndexName = $r["Index Name"]
            $rColumnName = $r["Indexed Column Names"]
            $rIncludedCol = $r["Included Column Names"]

            if($rIndexName -eq $IndexName){
                if($Include -eq $true){
                    if($rIncludedCol.Length -gt 0){
                        $r["Included Column Names"] += " " + $ColumnName
                    }else{
                        $r["Included Column Names"] = $ColumnName
                    }
                    if($ColumnName -ne "idA2A2"){
                        $r["Included Column Names without idA2A2"] += " " + $ColumnName
                    }
                }else{
                    $r["Indexed Column Names"] += " " + $ColumnName
                    if($ColumnName -ne "idA2A2"){
                        $r["Indexed Column Names without idA2A2"] += " " + $ColumnName
                    }
                }
                break
            }   
        }
    }
}

#Review $currentTable for duplidates
function performDupeCheck{
    foreach($row in $currentTable.tables[0]){
        $TableName = $row["Table Name"]
        $IndexName = $row["Index Name"]
        $ColumnName = $row["Indexed Column Names"]
    
        $rows = $currentTable.tables[0].Where({$_."Index Name" -ne $IndexName -And $_."Indexed Column Names" -eq $ColumnName})
    
        if($rows -ne $null){
            $results.tables[0].ImportRow($row)
        }
    }

    foreach($row in $currentTable.tables[0]){
        $TableName = $row["Table Name"]
        $IndexName = $row["Index Name"]
        $ColumnName = $row["Indexed Column Names without idA2A2"]
        $Include = $row["Included Column Names without idA2A2"]
    
        $rows = $currentTable.tables[0].Where({$_."Index Name" -ne $IndexName -And $_."Indexed Column Names without idA2A2" -eq $ColumnName -And $_."Included Column Names without idA2A2" -eq $Include})
    
        if($rows -ne $null){
            $results.tables[1].ImportRow($row)
        }
    }
}

foreach($row in $global:IndexesResults.tables[0]){
    $TableName = $row["Table Name"]
    $IndexName = $row["Index Name"]
    $ColumnName = $row["Column Name"]
    $ColmID = $row["COLM_ID"]
    $IndexType = $row["Index Type"]
    $Include = $row["Include"]

    #Ignore PK indexes
    if($row.Where({$IndexType -ne "UNIQUE CLUSTERED"})){
        $listTableName = $currentTable.tables[0].Rows[0]."Table Name"
        if($TableName -eq $listTableName){
            indexRow
        }else{
            foreach($r in $currentTable.tables[0]){
                $rTableName = $r["Table Name"]
                $rIndexName = $r["Index Name"]
                $rColumnName = $r["Indexed Column Names"]        
            }
            performDupeCheck
            $currentTable = $results.Clone()
            importRowIntoCurrentTable($row)
        }
    }

}

WriteToHtml '<h1>Duplicate Indexes (ignore included columns)</h1>'
.\ps1\00_TableToHtml.ps1 -tableID 0 -textOutput $false -excludeAdditionalColumns "Indexed Column Names without idA2A2, Included Column Names without idA2A2"

$htmlOut = "
<br>
<hr>
<br>
<h1>Duplicate Indexes (ignore idA2a2)</h1>
<br>
"
WriteToHtml $htmlOut

.\ps1\00_TableToHtml.ps1 -tableID 1 -textOutput $false


$comments = 
"Look for similar indexes that could be duplicates. This check ignores idA2A2 as this column is always included in non-clustered indexes.
<b>Dupe index_key_columns without PK</b> = Indexed Column Names + Included Column Names - idA2A2

Known Issues: <a href='https://www.ptc.com/en/support/article?n=CS265415'>CS265415</a> and <a href='https://www.ptc.com/en/support/article?n=CS304554'>CS304554</a>

Each index should be reviewed carefully before dropping. Contact PTC Technical Support if assistance is required.

Example: these indexes are identical:
<ul><li>create index EPMInitialCheckinData$example1 on EPMInitialCheckinData(classnamekeyB3, idA3B3) ON INDX;</li>
<li>create index EPMInitialCheckinData$example2 on EPMInitialCheckinData(classnamekeyB3, idA3B3, idA2A2) ON INDX;</li>
<li>create index EPMInitialCheckinData$example3 on EPMInitialCheckinData(classnamekeyB3, idA3B3) include (idA2A2) ON INDX;</li></ul>

See <a href='http://sqlblog.com/blogs/kalen_delaney/archive/2010/03/07/more-about-nonclustered-index-keys.aspx'>More About Nonclustered Index Keys</a> for a detailed explaination on how these are duplicate indexes."
Comments $comments

Footer
