$global:execute_time = Get-Date -format $dateFormat
$StopWatch = [system.diagnostics.stopwatch]::startNew()

[string]$query = (Get-Content .\sql\SpeedTest\QueryStoreAvgRowCount_metrics.sql) -join "`n"
$query = $query -replace "ENTER_PLAN_ID","$planId"
. .\ps1\00_executeQuery.ps1

foreach($row in $results.tables[0])
{
    $queryId = $row.Item("query_id")
    
    $text = $row.Item("text")
    . .\ps1\00_formatSQL.ps1

    $htmlOut = "
<tr>
<td><a href='QueryStoreTopSql.html#$queryId'>$queryId</td>
<td>$planId</td>
<td>$($row['LastExecution'])</td>
<td>$($row['Executions'])</td>
<td>$($row['TotalSec'])</td>
<td>$($row['AvgSec'])</td>
<td>$($row['AvgLogicalReads'])</td>
<td>$($row['AvgLogicalWrites'])</td>
<td>$($row['AvgPhysicalReads'])</td>
<td>$AvgRowCount</td>
<td>$($row['MinRowCount'])</td>
<td>$($row['MaxRowCount'])</td>
<td>$text</td>
</tr>
"
    WriteToHtml $htmlOut

}

$StopWatch.Stop()
$elapsed = [math]::Round($StopWatch.Elapsed.TotalSeconds,1)

DebugLog "Gathered metrics for plan_id $planId in $elapsed seconds" -logOnly $true
