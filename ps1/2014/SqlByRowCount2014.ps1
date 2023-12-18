$title = "Worst SQL by Row Count"

Header $title

[string]$query = (Get-Content .\sql\2014\SqlByRowCount.sql) -join "`n"
. .\ps1\00_executeQuery.ps1

if($failedQuery -eq $false){
$htmlOut = "
<table class=sortable>
<tr>
<th scope='col'>QueryHash</th>
<th scope='col'>Executions</th>
<th scope='col'>TotalRows</th>
<th scope='col'>AvgRows</th>
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
<td><a href='FullSqlTextAndPlans2014.html#$queryHash'>$queryHash</a></td>
<td>$($row['execution_count'])</td>
<td>$($row['total_rows'])</td>
<td>$($row['AvgRows'])</td>
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
