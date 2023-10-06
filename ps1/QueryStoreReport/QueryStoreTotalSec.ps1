$title = "Query Store by Total Seconds"

Header $title -newColumn $true

[string]$query = (Get-Content .\sql\QueryStoreTotalSec.sql) -join "`n"
. .\ps1\00_executeQuery.ps1

if($failedQuery -eq $false){
$htmlOut = "
<table class='sortable'>
<tr>
<th scope='col'>query_id</th>
<th scope='col'>plan_id</th>
<th scope='col'>LastExecution</th>
<th scope='col'>Executions</th>
<th scope='col'>TotalSec</th>
<th scope='col'>AvgSec</th>
<th scope='col'>MinSec</th>
<th scope='col'>MaxSec</th>
<th scope='col'>AvgCpuSec</th>
<th scope='col'>AvgLogicalReads</th>
<th scope='col'>AvgLogicalWrites</th>
<th scope='col'>AvgPhysicalReads</th>
<th scope='col'>AvgRowCount</th>
<th scope='col'>Text</th>
</tr>
"
WriteToHtml $htmlOut

foreach($row in $results.tables[0])
{
    $queryId = $row.Item("query_id")
    
    $text = $row.Item("text")
    . .\ps1\00_formatSQL.ps1

    $htmlOut = "
<tr>
<td><a href='QueryStoreTopSql.html#$queryId'>$queryId</td>
<td>$($row['plan_id'])</td>
<td>$($row['LastExecution'])</td>
<td>$($row['Executions'])</td>
<td>$($row['TotalSec'])</td>
<td>$($row['AvgSec'])</td>
<td>$($row['MinSec'])</td>
<td>$($row['MaxSec'])</td>
<td>$($row['AvgCpuSec'])</td>
<td>$($row['AvgLogicalReads'])</td>
<td>$($row['AvgLogicalWrites'])</td>
<td>$($row['AvgPhysicalReads'])</td>
<td>$($row['AvgRowCount'])</td>
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
