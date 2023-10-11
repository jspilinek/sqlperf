$title = "Query Store Top SQL"
$textpath = ".\html\$currentScript.txt"

function Format-XML {
  [CmdletBinding()]
  Param ([Parameter(ValueFromPipeline=$true,Mandatory=$true)][string]$xmlcontent)
  $xmldoc = New-Object -TypeName System.Xml.XmlDocument
  $xmldoc.LoadXml($xmlcontent)
  $sw = New-Object System.IO.StringWriter
  $writer = New-Object System.Xml.XmlTextwriter($sw)
  $writer.Formatting = [System.XML.Formatting]::Indented
  $xmldoc.WriteContentTo($writer)
  $sw.ToString()
}

Header $title -text $true -lineBreak $true
Set-Content -Path $textpath -Value "*******************************************************************************************************************"

InitProgressBar -Steps $trackedQueryIDs.Count -Activity $title
foreach($queryId in $trackedQueryIDs.Keys)
{
    # $source = $($trackedQueryIDs["$queryId"])

    # "QueryID: $queryId Source: $source"

#Output: Query ID metrics
    [string]$query = (Get-Content .\sql\QueryStore\QueryStoreTopSql.sql) -join "`n"
    $query = $query -replace "ENTER_QUERY_ID","$queryId"
    . .\ps1\00_executeQuery.ps1

    $htmlOut = "
<h2 id='$queryId'>queryId: <b>$queryId</b></h2>
<table>
<tr>
<th scope='col'>LastExecutionTime</th>
<th scope='col'>Executions</th>
<th scope='col'>TotalSec</th>
<th scope='col'>AvgSec</th>
<th scope='col'>AvgCpuSec</th>
<th scope='col'>TotalLogicalReads</th>
<th scope='col'>AvgLogicalReads</th>
<th scope='col'>TotalLogicalWrites</th>
<th scope='col'>AvgLogicalWrites</th>
<th scope='col'>TotalPhysicalReads</th>
<th scope='col'>AvgPhysicalReads</th>
<th scope='col'>AvgRowCount</th>
<th scope='col'>AvgDOP</th>
<th scope='col'>AvgQueryMaxUsedMemory</th>
</tr>"

    WriteToHtml $htmlOut

    foreach($row in $results.tables[0])
    {
        $htmlOut = "
<tr>
<td>$($row['last_execution_time'])</td>
<td>$($row['Executions'])</td>
<td>$($row['TotalSec'])</td>
<td>$($row['AvgSec'])</td>
<td>$($row['AvgCpuSec'])</td>
<td>$($row['TotalLogicalReads'])</td>
<td>$($row['AvgLogicalReads'])</td>
<td>$($row['TotalLogicalWrites'])</td>
<td>$($row['AvgLogicalWrites'])</td>
<td>$($row['TotalPhysicalReads'])</td>
<td>$($row['AvgPhysicalReads'])</td>
<td>$($row['AvgRowCount'])</td>
<td>$($row['AvgDOP'])</td>
<td>$($row['AvgQueryMaxUsedMemory'])</td>
</tr>"

        WriteToHtml $htmlOut

        $excludeColumns = "RowError, RowState, Table, ItemArray, HasErrors, text" -split ", "
        $row | select $columns -ExcludeProperty $excludeColumns | Format-Table -Property * -AutoSize | Out-String -Width 4096 | Out-File -encoding ASCII -append -FilePath $textpath
    }

    $htmlOut = "
</table>
<br>
"
    WriteToHtml $htmlOut

#Output: Individual Plan metrics
    .\ps1\QueryStoreTopPlans.ps1


#Output: SQL Text
    [string]$query = (Get-Content .\sql\QueryStore\QueryStoreText.sql) -join "`n"
    $query = $query -replace "ENTER_QUERY_ID","$queryId"
    . .\ps1\00_executeQuery.ps1

    foreach($row in $results.tables[0]){
        [string]$sqlText = $row.Item("query_sql_text")
        $htmlOut = "
<br>
$sqlText
<br>
<br>
<hr>
"
        WriteToHtml $htmlOut
    }

    .\ps1\00_WrapText.ps1
    WriteToFileNewline $textpath
    WriteToFileNewline $textpath
    WriteToText "*******************************************************************************************************************"

    UpdateProgressBar
}

CompleteProgressBar

#Delete all tracked query IDs
$global:trackedQueryIDs.clear()

Footer
