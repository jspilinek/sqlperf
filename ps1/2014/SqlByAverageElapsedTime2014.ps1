$title = "Worst SQL by Average Elapsed Time"

Header $title

[string]$query = (Get-Content .\sql\2014\SqlByAverageElapsedTime.sql) -join "`n"
. .\ps1\00_executeQuery.ps1

if($failedQuery -eq $false){
$htmlOut = "
<table class=sortable>
<tr>
<th scope='col'>QueryHash</th>
<th scope='col'>ElapsedTimeSec</th>
<th scope='col'>CpuSec</th>
<th scope='col'>Executions</th>
<th scope='col'>AvgSec</th>
<th scope='col'>MinSec</th>
<th scope='col'>MaxSec</th>
<th scope='col'>TotalRows</th>
<th scope='col'>LastExec</th>
<th scope='col'>Text</th>
<th scope='col'>sql_handle</th>
<th scope='col'>plan_handle</th>
</tr>
"

WriteToHtml $htmlOut

foreach($row in $results.tables[0])
{
    $queryHash = $row.Item("QueryHash")

    $htmlOut = "
<tr>
<td><a href='FullSqlTextAndPlans.html#$queryHash'>$queryHash</a></td>
<td>$($row['ElapsedTimeSec'])</td>
<td>$($row['CpuSec'])</td>
<td>$($row['execution_count'])</td>
<td>$($row['AvgSec'])</td>
<td>$($row['MinSec'])</td>
<td>$($row['MaxSec'])</td>
<td>$($row['total_rows'])</td>
<td>$($row['last_execution_time'])</td>
<td>$($row['text'])</td>
<td>$($row['sql_handle'])</td>
<td>$($row['plan_handle'])</td>
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
