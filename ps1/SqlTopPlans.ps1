[string]$query = (Get-Content .\sql\SqlTopPlans.sql) -join "`n"
$query = $query -replace "ENTER_QUERY_HASH","$queryHash"
. .\ps1\00_executeQuery.ps1

$htmlOut = "
<table>
<tr>
<th scope='col'>sqlplan</th>
<th scope='col'>last_execution_time</th>
<th scope='col'>Executions</th>
<th scope='col'>TotalSec</th>
<th scope='col'>AvgSec</th>
<th scope='col'>AvgLogicalReads</th>
<th scope='col'>AvgPhysicalReads</th>
<th scope='col'>HasMissingIndex</th>
<th scope='col'>plan_handle</th>
<th scope='col'>sql_handle</th>
</tr>
"
WriteToHtml $htmlOut
WriteToText "----------------------------------------------------------------------------------------------------"

$i = 1
foreach($row in $results.tables[0])
{
    $global:execute_time = Get-Date -format "yyyy-MM-dd HH:mm:ss"
    $StopWatch = [system.diagnostics.stopwatch]::startNew()

    $planId = $($row["plan_id"])

    #make sure the plan is not an empty string
    #if($($row['query_plan'])){
    if([string]::IsNullOrWhiteSpace($($row['query_plan']))){
        DebugLog "Plan missing for $planPath$queryHash-$i.sqlplan"
    }else{
        DebugLog "Generating $planPath$queryHash-$i.sqlplan"
        Try{
            $($row['query_plan']) | Format-XML | Out-File -FilePath "$planPath$queryHash-$i.sqlplan" -Encoding utf8
        }Catch{
            LogException $_.Exception $error[0].ScriptStackTrace "Failed to generate sqlplan for queryHash: $queryHash-$i" $text
        }
    }

    $htmlOut = "
<tr>
<td><a href='sqlplan/$queryHash-$i.sqlplan' type='xml/sqlplan'>$queryHash-$i.sqlplan</a></td>
<td>$($row['last_execution_time'])</td>
<td>$($row['execution_count'])</td>
<td>$($row['TotalSec'])</td>
<td>$($row['AvgSec'])</td>
<td>$($row['AvgLogicalReads'])</td>
<td>$($row['AvgPhysicalReads'])</td>
<td>$($row['Has Missing Index'])</td>
<td>$($row['plan_handle'])</td>
<td>$($row['sql_handle'])</td>
<tr>
"
    WriteToHtml $htmlOut
    
    WriteToText "$queryHash-$i.sqlplan"
    
    $textOut = 
"SQLPlan          : $queryHash-$i.sqlplan 
LastExecutionTime : $($row['last_execution_time']) 
Executions        : $($row['execution_count']) 
TotalSec          : $($row['TotalSec']) 
AvgSec            : $($row['AvgSec']) 
AvgLogicalReads   : $($row['AvgLogicalReads']) 
AvgPhysicalReads  : $($row['AvgPhysicalReads']) 
HasMissingIndex   : $($row['Has Missing Index']) 
plan_handle       : $($row['plan_handle']) 
sql_handle        : $($row['sql_handle']) 
"
    WriteToText $textOut
    WriteToText "----------------------------------------------------------------------------------------------------"

    $StopWatch.Stop()
    $elapsed = [math]::Round($StopWatch.Elapsed.TotalSeconds,1)

    DebugLog "$planPath$queryHash-$i.sqlplan generated in $elapsed seconds" -logOnly $true

    $i++
}

$htmlOut = "
</table>
"
WriteToHtml $htmlOut

WriteToFileNewline $textpath
