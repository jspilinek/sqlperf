$title = "DupeIndexes"

Header $title

#Clone the structure of the DataSet from Tables.ps1
# $results = $global:IndexesResults.Clone()
$results = New-Object System.Data.DataSet
$resultsTab = New-Object System.Data.DataTable
$resultsTabB = New-Object System.Data.DataTable

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

$results.tables.Add($resultsTab)
$results.tables.Add($resultsTabB)

# $currentTable = $global:IndexesResults.Clone()
$currentTable = $results.Clone()

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

    # "NewRow:"
    # $newRow

    $currentTable.tables[0].Rows.Add($newRow)

    # foreach ($r in $currentTable.Tables[0])
    # {
    #     "Row: $r"
    #     $r
    # }

}

function indexRow{
    if ($ColmID -eq 1){
        # $currentTable.tables[0].ImportRow($row)
        importRowIntoCurrentTable($row)
        # "indexRow{} ColmID = 1"
    }else{
        # $cnt = $currentTable.tables[0].Rows.Count
        # "indexRow{} Count: $cnt"
        foreach($r in $currentTable.tables[0]){
            $rTableName = $r["Table Name"]
            $rIndexName = $r["Index Name"]
            $rColumnName = $r["Indexed Column Names"]
            $rIncludedCol = $r["Included Column Names"]
            # $rColmID = $r["COLM_ID"]

            # "$rTableName $rIndexName $rColumnName"

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
                # "Updated row"
                break
            }   
        }
    }
}

function performDupeCheck{
    # $cnt = $currentTable.tables[0].Rows.Count
    # "performDupeCheck() currentTable Count: $cnt"

    foreach($row in $currentTable.tables[0]){
        $TableName = $row["Table Name"]
        $IndexName = $row["Index Name"]
        $ColumnName = $row["Indexed Column Names"]
    
        # $rows = $currentTable.tables[0].Where({$_."Table Name" -eq $TableName -And $_."Index Name" -ne $IndexName -And $_."Column Name" -eq $ColumnName})
        $rows = $currentTable.tables[0].Where({$_."Index Name" -ne $IndexName -And $_."Indexed Column Names" -eq $ColumnName})
    
        if($rows -ne $null){
            $results.tables[0].ImportRow($row)
        }
        # foreach ($finding in $rows){
        #     # $row
        #     # $finding
        #     $results.tables[0].ImportRow($row)
        # }
    }

    foreach($row in $currentTable.tables[0]){
        $TableName = $row["Table Name"]
        $IndexName = $row["Index Name"]
        $ColumnName = $row["Indexed Column Names without idA2A2"]
        $Include = $row["Included Column Names without idA2A2"]
    
        # $rows = $currentTable.tables[0].Where({$_."Table Name" -eq $TableName -And $_."Index Name" -ne $IndexName -And $_."Column Name" -eq $ColumnName})
        $rows = $currentTable.tables[0].Where({$_."Index Name" -ne $IndexName -And $_."Indexed Column Names without idA2A2" -eq $ColumnName -And $_."Included Column Names without idA2A2" -eq $Include})
    
        if($rows -ne $null){
            $results.tables[1].ImportRow($row)
        }
        # foreach ($finding in $rows){
        #     # $row
        #     # $finding
        #     $results.tables[0].ImportRow($row)
        # }
    }

    #2nd dupe check ignoring idA2A2
    # if($TableName -eq "EPMDocumentMaster"){
    #     $withoutPK = $currentTable.Tables[0].Clone()
    #     foreach($row in $currentTable.tables[0]){

    #         $TableName = $row["Table Name"]
    #         $IndexName = $row["Index Name"]
    #         $ColumnName = $row["Indexed Column Names"]

    #         "$TableName $IndexName $ColumnName"
    
    #         $test1 = $row["Indexed Column Names"].Replace("idA2A2", "")
    #         $test2 = $row["Included Column Names"].Replace("idA2A2", "")
    
    #         "test1: $test1"
    #         "test2: $test2"
    
    #     }
    # }
}

# Schema Name      : wind
# Table Name       : AutoVaultCleanupCriteria
# Index Name       : PK_AutoVaultCleanupCriteria
# Column Name      : idA2A2
# COLM_ID          : 1
# Sort             : ASC
# Include          : False
# Index Type       : UNIQUE CLUSTERED
# rows             : 0
# total_pages      : 0
# used_pages       : 0
# Data Compression : NONE
# Index Size MB    : 0.000
# Hypothetical     : False

# $TotalItems=$global:IndexesResults.tables[0].Rows.Count
$i=0
# $PercentComplete = 0

foreach($row in $global:IndexesResults.tables[0]){
    # Write-Progress -Activity "Duplicate Check" -Status "$PercentComplete% Complete:" -PercentComplete $PercentComplete

    $TableName = $row["Table Name"]
    $IndexName = $row["Index Name"]
    $ColumnName = $row["Column Name"]
    $ColmID = $row["COLM_ID"]
    $IndexType = $row["Index Type"]
    $Include = $row["Include"]

    # "$TableName $IndexName $ColumnName $ColmID"

    # if($row.Where({$_."COLM_ID" -eq 1 -And $_."Table Name" -eq "EPMFamilyTableCell"})){
    # if($row.Where({$_."COLM_ID" -eq 1 -And $_."Index Type" -ne "UNIQUE CLUSTERED"})){
    if($row.Where({$IndexType -ne "UNIQUE CLUSTERED"})){
    # if($row.Where({$IndexType -ne "UNIQUE CLUSTERED" -And $TableName -eq "EPMDocumentMaster"})){
        # "$TableName $IndexName $ColumnName $ColmID"

        # AddRow($row)
        # if($currentTable.tables[0].Rows.Count -eq 0){
        #     $currentTable.tables[0].ImportRow($row)
        #     "Added $TableName to empty list"
        # }else{
            $listTableName = $currentTable.tables[0].Rows[0]."Table Name"
            # "list table name: $listTableName"
            if($TableName -eq $listTableName){
                # "Found $TableName in existing list"
                # $currentTable.tables[0].ImportRow($row)
                indexRow
            }else{
                foreach($r in $currentTable.tables[0]){
                    $rTableName = $r["Table Name"]
                    $rIndexName = $r["Index Name"]
                    $rColumnName = $r["Indexed Column Names"]        

                    # "DupeIndexes Import row: $rTableName $rIndexName $rColumnName"
                    # $DupeIndexes.tables[0].ImportRow($r)
                }
                performDupeCheck

                # "Reset list"
                $currentTable = $results.Clone()
                # $currentTable.tables[0].ImportRow($row)
                importRowIntoCurrentTable($row)
            }
        # }
        # $cnt = $currentTable.tables[0].Rows.Count
        # "Current list count: $cnt"

        # "CurrentTable:"
        # $currentTable.tables[0]
        # "CurrentTable Table Name"
        # $currentTable.tables[0].Rows[0]."Table Name"
    
    }else{

    }

    # if($i -eq 40){
    #     break
    # }
    $i++
    # $PercentComplete = [int](($i / $TotalItems) * 100)
}

# Write-Progress -Activity "Duplicate Check" -Completed

# $cnt = $DupeIndexes.tables[0].Rows.Count
# "DupeIndexes count: $cnt out of $i"
# foreach($row in $DupeIndexes.tables[0]){
#     $TableName = $row["Table Name"]
#     $IndexName = $row["Index Name"]
#     $ColumnName = $row["Column Name"]

#     $row
# }

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
