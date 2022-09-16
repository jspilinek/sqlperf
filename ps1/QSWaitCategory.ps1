param(
    [int]$category,
    [string]$desc
)

$title = "Query Store by $desc Waits"

Header $title

[string]$query = (Get-Content .\sql\QSWaitCategory.sql) -join "`n"
$query = $query -replace "ENTER_WAIT_CATEGORY","$category"
. .\ps1\00_executeQuery.ps1

if($failedQuery -eq $false){
$htmlOut = "
<table class='sortable'>
<tr>
<th scope='col'>query_id</th>
<th scope='col'>plan_id</th>
<th scope='col'>TotalWait_ms</th>
<th scope='col'>MaxAvgWait_ms</th>
<th scope='col'>MinAvgWait_ms</th>
<th scope='col'>execution_type</th>
<th scope='col'>Text</th>
</tr>
"
WriteToHtml $htmlOut

foreach($row in $results.tables[0])
{
    $queryId = $row.Item("query_id")

    $text = $row.Item("text")
    . .\ps1\00_formatSQL.ps1 -fullText $true

    $htmlOut = "
<tr>
<td><a href='QueryStoreTopSql.html#$queryId'>$queryId</td>
<td>$($row['plan_id'])</td>
<td>$($row['TotalWait_ms'])</td>
<td>$($row['MaxAvgWait_ms'])</td>
<td>$($row['MinAvgWait_ms'])</td>
<td>$($row['execution_type'])</td>
<td>$text</td>
</tr>
"
    WriteToHtml $htmlOut
}

$htmlOut = "
</table>
"
WriteToHtml $htmlOut
}else{
    WriteToHtml "<p class='failedQuery'>Failed to execute query:</p>"
    WriteToHtml "<p class='failedQuery'>$query</p>"
    WriteToHtml "<p class='failedQuery'> Refer to <a href='debug.txt'>debug.txt</a> for details"
}

Footer
