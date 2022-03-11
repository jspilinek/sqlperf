[string]$query = (Get-Content .\sql\QueryStoreTopPlans.sql) -join "`n"
$query = $query -replace "ENTER_QUERY_ID","$queryId"
. .\ps1\00_executeQuery.ps1

$col1 = New-Object system.Data.DataColumn sqlplan_link,([string])
$col2 = New-Object system.Data.DataColumn sqlplan_file,([string])

$results.tables[0].columns.add($col1)
$results.tables[0].columns.add($col2)

$results.tables[0].columns["sqlplan_link"].SetOrdinal(0);
$results.tables[0].columns["sqlplan_file"].SetOrdinal(1);

#Generate top 3 sqlplan files by last_execution_time
$i = 1
foreach($row in $results.tables[0])
{
    $global:execute_time = Get-Date -format "yyyy-MM-dd HH:mm:ss"
    $StopWatch = [system.diagnostics.stopwatch]::startNew()

    $planId = $($row["plan_id"])
    $row.sqlplan_link = "<a href='sqlplan/$queryId-$planId.sqlplan' type='xml/sqlplan'>$queryId-$planId.sqlplan</a>"
    $row.sqlplan_file = "$queryId-$planId.sqlplan"
    
    DebugLog "Generating $planPath$queryId-$planId.sqlplan"
    $($row["query_plan"]) | Format-XML | Out-File -FilePath "$planPath$queryId-$planId.sqlplan" -Encoding utf8

    $StopWatch.Stop()
    $elapsed = [math]::Round($StopWatch.Elapsed.TotalSeconds,1)

    DebugLog "$planPath$planId.sqlplan generated in $elapsed seconds" -logOnly $true
    
    if($i++ -eq 3){ break };
}

.\ps1\00_TableToHtml.ps1 -tableID 0 -excludeAdditionalColumns "query_plan, sqlplan_file" -link $true
.\ps1\00_TableToHtml.ps1 -tableID 0 -textOutput $true -htmlOutput $false -excludeAdditionalColumns "query_plan, sqlplan_link"
